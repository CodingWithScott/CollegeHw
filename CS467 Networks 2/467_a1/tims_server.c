/*
 *          TIMS:   Totally Insecure Messaging System
 * 
 *      This server portion stores and retrieves messages from the
 *      gdbm database and passes them back to the client.        
 */
#include <stdio.h>              /* String parsing. snprintf(3) */
#include <time.h>               /* Printing timestamps. ctime(3) */

#include "gdbm-1.8.3/gdbm.h"    /* Include database dependencies. gdbm(3) */
/* does it matter which place I have gdbm included from? */
// #include </home/felchs/gdbm-1.8.3/gdbm.h>
#include <string.h>             /* Null out datum fields properly. memset(3) */
#include "tims.h"               /* rpc generated master header file */

/* Accepts a flattened string and reassembles it into a struct. */
void blow_up(char* flat_msg, message* outgoing_msg) {
    strncpy(outgoing_msg->to, flat_msg, NAME_LEN);
    strncpy(outgoing_msg->from, &flat_msg[32], NAME_LEN);
    outgoing_msg->datetime = atoi(&flat_msg[64]);
    strncpy(outgoing_msg->body, &flat_msg[72], MSG_LEN);

    // printf("blowup(): outgoing_msg.datetime:\t%d\n", outgoing_msg->datetime);
}

/* Accepts a message struct and returns a flattened string. */
char* flatten(message msg) {
    /* Static to avoid giving client a reference to server's local stack. */
    static char flat_msg[STRUCT_LEN];   

    /* strncpy(3) lets us write to certain places and assign NULL elsewhere 
       snprintf(3) does this same thing for integers. */
    strncpy(flat_msg, msg.to, NAME_LEN);                    // writes [0..31]
    strncpy(&flat_msg[32], msg.from, NAME_LEN);             //   ""   [32..63]
    snprintf(&flat_msg[64], EPOCH_LEN, "%d", msg.datetime); //   ""   [64..71]
    strncpy(&flat_msg[72], msg.body, MSG_LEN);              //   ""   [72..327]

    return flat_msg;
}

/* Compare min-unread and max-unread substrings against each other to 
   determine if the user's mailbox is full (for PUT) or empty (for GET). */
int full_or_empty(datum name_value_datum) {
    char name_value[8];
    char min_unread[4];
    char max_unread[4];
    memset(min_unread, 0, 5);       /* Double check null terminator */
    memset(max_unread, 0, 5);       

    strncpy(name_value, name_value_datum.dptr, (size_t) 8); 
    strncpy(min_unread, name_value, (size_t) 4);
    strncpy(max_unread, &name_value[4], (size_t) 4);
 
    printf("DEBUG full_or_empty():\n");
    printf("\tname_value_datum.dptr:\t%s\n", name_value_datum.dptr);
    printf("\tname_value:\t%s\n", name_value);
    printf("\tmin_unread:\t%s\n", min_unread);
    printf("\tmax_unread:\t%s\n", max_unread);
 
    /* Mailbox is full! */ 
    if (strncmp(min_unread, max_unread, (size_t) 4) == 0)  
        return 1;   
 
    return 0;
}

/* Prints the entirety of a string, including null padding. */
void nullprint(char* input, int length) {
    int ix;
    for (ix = 0; ix < length; ix++) {
        if (input[ix] == 0)
            printf("0");
        else
            printf("%c", input[ix]);

        fflush(stdout);
    }
    printf("\n");
}

/* Print a message struct to screen */
void print_message(message* msg) {
    /* Stuff for storing/displaying timestamp info. See strftime(3). */
    const int   MAX_TIME_SIZE = 50;
    char        time_str[MAX_TIME_SIZE];
    struct      tm *tmp;

    time_t epoch = msg->datetime;
    tmp = localtime(&epoch);

    printf("\tTo:\t%s\n", msg->to);
    printf("\tFrom:\t%s\n", msg->from);
    printf("\tTime:\t");
    strftime(time_str, MAX_TIME_SIZE, "%a %b %e %H:%M:%S %Y", tmp);
    printf("%s\n", time_str);
    printf("\tBody:\t%s\n", msg->body);
} 

/* Returns integer value of number of unread messages */
int unread_messages(datum name_value_datum) {
    char name_value[8];
    char min_unread_pos_str[4];     /* pos = position */
    char max_unread_pos_str[4];
    int min_unread_pos;
    int max_unread_pos;
    int total_unread;

    strncpy(name_value, name_value_datum.dptr, (size_t) 8); 
    strncpy(min_unread_pos_str, name_value, (size_t) 4);
    strncpy(max_unread_pos_str, &name_value[4], (size_t) 4);

    min_unread_pos = atoi(min_unread_pos_str);
    max_unread_pos = atoi(max_unread_pos_str);
    total_unread = max_unread_pos - min_unread_pos;

    /* Handle index overflowing 9999 -> 0000 */
    if (total_unread < 0)
        total_unread = total_unread * -1;
 
    printf("DEBUG unread_messages():\n");
    printf("\tmin_unread_pos:\t%d\n", min_unread_pos);
    printf("\tmax_unread_pos:\t%d\n", max_unread_pos);
    printf("\ttotal_unread:\t%d\n", total_unread);

    return total_unread;   
}


/*      PUT function
   Input:    -a pre-constructed message (previously argp) to store
             -request structure containing rpc_gen routing 
              information. Unused in thie application.
   Return:  An integer error code. 

            Database roles:
    names_db stores metainfo about messages.
        Format:     (key = name, value = [min unread][max unread])
        ie, ("Scott", "00000001") 
    msg_db stores actual messages
        Format:     (key = [name][unread index], value = flat message)  
        ie, ("Scott0001", value = "this is a flattened struct") 

            Values used for queries:
    -name_key is a username in the "to" field of messages.
    -name_value is location of first and last unread messages concatenated,
        ie "00010008".
    -msg_key is a username concatenated with a message location,
        ie "scott0001". 
    -msg_value is a flattened string representation of a message struct. */     
int *tims_put_1_svc(message *msg_to_store, struct svc_req *rqstp) {
    static int  error_code;     /* Error code for PUT operation */
    char* msg_value;            /* Contains a flattened struct to store in msg_db */

    /* Stamp time of arrival onto message */
    time_t secs_since_epoch = time(NULL);
    msg_to_store->datetime = secs_since_epoch;

        /* DEBUG: confirm message was received intact */
    printf("\nMessage received.\n");
    msg_value = flatten(*msg_to_store);
    printf("Message flattened.\n\n");   
        // nullprint(msg_value, STRUCT_LEN);
    
    /* Open the databases in read-write mode, overwrite any existing file. */
    GDBM_FILE names_db = gdbm_open("names_db", 0, GDBM_WRCREAT, 0644, 0);
    GDBM_FILE msg_db   = gdbm_open("msg_db",   0, GDBM_WRCREAT, 0644, 0);               

    /* Store all input data from message into local buffers. Wipe with 0s out
       of paranoia. */
    char to[NAME_LEN];
        memset(to, 0, NAME_LEN);    
        strncpy(to, msg_to_store->to, NAME_LEN);
    char from[NAME_LEN];
        memset(from, 0, NAME_LEN);
        strncpy(from, msg_to_store->from, NAME_LEN);
    char datetime[EPOCH_LEN];
        memset(datetime, 0, EPOCH_LEN);
        snprintf(datetime, EPOCH_LEN, "%ld", secs_since_epoch);
    char body[MSG_LEN];
        memset(body, 0, MSG_LEN);
        strncpy(body, msg_to_store->body, MSG_LEN);
        /* DEBUG: */

    /* Generate new strings to work with */
    char name_value[9];                     /* Contents of name_value_datum */
        memset(name_value, 0, 9);           /* Extra byte for null terminator */
        // strncpy(name_value, "00000000", 8);
    char msg_key[NAME_LEN+4];               /* Contents of msg_key_datum */
        memset(msg_key, 0, NAME_LEN+4);     
        strncpy(msg_key, to, NAME_LEN);     /* Append the 0001 suffix later */

    /* Generatee (key,value) combinations for the 4 different queries. Data 
       must be in a datum struct for use with gdbm. */
    datum name_key_datum;
        name_key_datum.dptr = to;               /* ex: "Scott Felch" */
        name_key_datum.dsize = NAME_LEN;
    datum name_value_datum;                 
        // name_value_datum.dptr = name_value;     /* ex: 00690420 */
        name_value_datum.dsize = 8;
    datum msg_key_datum;
        msg_key_datum.dptr = msg_key;           /* ex: "Scott Felch000...0001" */
        msg_key_datum.dsize = NAME_LEN + 4;
    datum msg_value_datum;
        msg_value_datum.dptr = msg_value;
        msg_value_datum.dsize = STRUCT_LEN;

    printf("Querying names_db for user '%s'...\n", to);
        printf("DEBUG:\tSegfaults tend to occur here.\n");
        printf("\tname_key_datum.dptr:\t");
        nullprint(name_key_datum.dptr, NAME_LEN);
        printf("\n");

    if (name_key_datum.dptr == NULL)
       printf("\t!!! Querying a null name from names_db !!!\n");

    name_value_datum = gdbm_fetch(names_db, name_key_datum);
    printf("DEBUG tims_put_1_svc():211\n");
        printf("\n\tname_value_datum.dptr:\t%s\n", name_value_datum.dptr);
        nullprint(name_value_datum.dptr, 8);

    /* The user is not present in the db, this is their first message. */
    if (name_value_datum.dptr == NULL) {
        printf("User not found, initializing new names_db entry... ");
    
        /* Make a name_value node to init their metainfo in names_db. */ 
        memset(name_value, 0, 9);
        strncpy(name_value, "00000001\0", 8);
        name_value_datum.dptr = name_value;
        name_value_datum.dsize = 8;

        /* Perform names_db insertion */
        nullprint(name_key_datum.dptr, NAME_LEN);
        if (name_key_datum.dptr == NULL)
            printf("\t!!! Inserting a null name_key into names_db !!!\n");
        if (name_value_datum.dptr == NULL)
            printf("\t!!! Inserting a null name_value into names_db !!!\n");

        error_code = gdbm_store(names_db, name_key_datum, name_value_datum, GDBM_REPLACE);
        if (error_code < 0) {
            printf("\nERROR: names_db insertion failure!\n");
            error_code = -1;
            return &error_code;
        }
        printf("Done.\n");

        /* Finish making a msg_key node with data from name_value node. */
        printf("\nDepositing message into msg_db... ");
        strncat(&msg_key[NAME_LEN], "0001", 4); /* Append after the null pad */
        printf("\n\tDEBUG:\tUsing msg_key:\t");
        nullprint(msg_key, NAME_LEN+4); 
        printf("\n");

        if (msg_key_datum.dptr == NULL)
            printf("\t!!! Inserting a null msg_key into msg_db !!!\n");
        if (msg_value_datum.dptr == NULL)
            printf("\t!!! Inserting a null msg_value into msg_db !!!\n");
            
        /* Perform msg_db insertion */
        error_code = gdbm_store(msg_db, msg_key_datum, msg_value_datum, GDBM_REPLACE);
        if (error_code < 0){
            printf("\nERROR: msg_db insertion failure!\n");
            error_code = -1;
            return &error_code;
        }
        printf("Done.\n");

        /* Now fetch datums from the database and print to check our work. */
        printf("DEBUG: Performing msg_db query (check our work) ***\n");
            datum name_datum_test = gdbm_fetch(names_db, name_key_datum);
            datum msg_datum_test = gdbm_fetch(msg_db, msg_key_datum);
            char* flat_msg_test = msg_datum_test.dptr;
            message msg_test;
            blow_up(flat_msg_test, &msg_test);

            printf("Message retrieved:\n");
            print_message(&msg_test);
    }
    /* The user already has 1 or more messages in the db. */
    else if (name_value_datum.dptr != NULL) {
        printf("DEBUG tims_put_1_svc():258\n");
        printf("\tname_value_datum.dptr:\t%s\n", name_value_datum.dptr);
        printf("PUT:\tUser has 1 or more messages already\n");
        /* Check if user's mailbox is empty */
        if (full_or_empty(name_value_datum)) {
             printf("User's inbox is full!\n");
             error_code = -1;
             return &error_code;
         }
         /* Increment max-unread portion of namekey */
        int max_unread = atoi(&name_value[4]);
        max_unread++;
        snprintf(&name_value[4], (size_t) 4, "%d", max_unread);
        name_value_datum.dptr = name_value;

        printf("\nDepositing message into msg_db...");
        error_code = gdbm_store(names_db, name_key_datum, name_value_datum, GDBM_REPLACE);
        if (error_code){
            printf("ERROR: names_db failed to update name_value.\n");
            error_code = -1;
            return &error_code;
        }
        printf("Done.\n");

        /* Insert into msg_db using the newly incremented max-unread value for
           [username][max_unread]  key format. */
        char max_unread_str[4];
        snprintf(max_unread_str, (size_t) 4, "%d", max_unread);
        strncat(&msg_key[NAME_LEN], max_unread_str, 4); 
        error_code = gdbm_store(msg_db, msg_key_datum, msg_value_datum, GDBM_REPLACE);


        /* Now fetch datums from the database and print to check our work. */
        printf("*** Performing msg_db query (check our work) ***\n");
            datum name_datum_test = gdbm_fetch(names_db, name_key_datum);
            datum msg_datum_test = gdbm_fetch(msg_db, msg_key_datum);
            char* flat_msg_test = msg_datum_test.dptr;
            message msg_test;
            blow_up(flat_msg_test, &msg_test);

            printf("Message retrieved:\n");
            print_message(&msg_test);


    }

    printf("Closing databases...\n");
    gdbm_close(msg_db);
    gdbm_close(names_db);
    printf("Goodbye!\n");

    error_code = 0;
    return &error_code;
}

/*      GET function 
    Input:      -name to retrieve messages for
                -request structure containing rpc_gen routing 
                 information. Unused in thie application. 
    Return:     -struct populated with first unread message */
message *tims_get_1_svc(name *to, struct svc_req *rqstp)  {
    static message  outgoing_msg;
    char msg_value[STRUCT_LEN];  /* Contains a flattened message struct */

    time_t rawtime;             /* Hold timestamp of message */
    struct tm* timeinfo;        /* Formatted time struct */

    /* Open msg_db in read-only, we never erase from there. */
    GDBM_FILE names_db = gdbm_open("names_db", 0, GDBM_WRCREAT, 0644, 0);
    GDBM_FILE msg_db   = gdbm_open("msg_db",   0, GDBM_READER, 0644, 0);

    /* Generate new strings to work with */
    char name_key[NAME_LEN];
        memset(name_key, 0, NAME_LEN+1);           /* Extra byte for null terminator */
        strncpy(name_key, *to, NAME_LEN);
    char name_value[9];                     /* Contents of name_value_datum */
        memset(name_value, 0, 9);           /* Extra byte for null terminator */
        strncpy(name_value, "00000000", 8);
    char msg_key[NAME_LEN+4];               /* Contents of msg_key_datum */
        memset(msg_key, 0, NAME_LEN+4);     
        strncpy(msg_key, *to, NAME_LEN);    /* Append the 0001 suffix later */

    /* Generate (key,value) combinations for the 2 database queries. */
    datum name_key_datum;
        name_key_datum.dptr = name_key;               /* ex: "Scott Felch" */
        name_key_datum.dsize = NAME_LEN;
    datum name_value_datum;                 
        name_value_datum.dptr = "00000000";     /* ex: 00690420 */
        name_value_datum.dsize = 8;

    /* If invalid user specified or no messages to retrieve then notify. */
    printf("DEBUG:\tSegfaults tend to occur here.\n");
    printf("\tname_key_datum.dptr:\t");
    nullprint(name_key_datum.dptr, NAME_LEN);
    printf("\n");
    if (gdbm_exists(names_db, name_key_datum) == 0) {
        time(&rawtime);
        timeinfo = localtime(&rawtime);
        outgoing_msg.datetime = rawtime;

        strncpy(outgoing_msg.to, *to, NAME_LEN);        
        strncpy(outgoing_msg.from, "TIMS Daemon", NAME_LEN);
        strncpy(outgoing_msg.body, "User ", 5);
        strncat(outgoing_msg.body, outgoing_msg.to, NAME_LEN);
        strncat(outgoing_msg.body, " not found.\n", 13);

        return &outgoing_msg;
    }
    else if (full_or_empty(name_value_datum)){
        time(&rawtime);
        timeinfo = localtime(&rawtime);
        outgoing_msg.datetime = rawtime;

        strncpy(outgoing_msg.from, "TIMS Daemon", NAME_LEN);
        strncpy(outgoing_msg.body, "User ", 5);
        strncat(outgoing_msg.body, outgoing_msg.to, NAME_LEN);
        strncat(outgoing_msg.body, " has 0 unread messages.\n", 13);
    }

    name_value_datum = gdbm_fetch(names_db, name_key_datum);

    /* Increment min-unread portion of namekey to indicate message received. */
    int min_unread = atoi(&name_value[4]);
    min_unread++;
    snprintf(&name_value[4], (size_t) 4, "%d", min_unread);

    datum msg_key_datum;
        msg_key_datum.dsize = NAME_LEN + 4;
    datum msg_value_datum;
        msg_value_datum.dsize = STRUCT_LEN;

    /* msg_key needs the message location to be appended to the name */
    char min_unread_str[4];
    snprintf(min_unread_str, (size_t) 4, "%d", min_unread);
    strncat(&msg_key[NAME_LEN], min_unread_str, 4); 
    strncpy(msg_key_datum.dptr, msg_key,  NAME_LEN+4);


    msg_value_datum = gdbm_fetch(msg_db, msg_key_datum);

    strncpy(msg_value, msg_value_datum.dptr, STRUCT_LEN);
    blow_up(msg_value, &outgoing_msg);





    return &outgoing_msg;
}

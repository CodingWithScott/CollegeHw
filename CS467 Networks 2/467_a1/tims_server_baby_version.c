/*
 *          TIMS:   Totally Insecure Messaging System
 * 
 *      This server portion stores and retrieves messages from the
 *      gdbm database and passes them back to the client.        
 */
#include <stdio.h>              /* String parsing. snprintf(3) */
#include <time.h>               /* Printing timestamps. ctime(3) */

#include "gdbm-1.8.3/gdbm.h"    /* Include database dependencies. gdbm(3) */
#include <string.h>             /* Null out datum fields properly. memset(3) */
#include "tims.h"               /* rpc generated master header file */

int *tims_put_1_svc(message *msg_to_store, struct svc_req *rqstp) {
    GDBM_FILE my_db = gdbm_open("my_db", 0, GDBM_WRCREAT, 0644, 0);

    char to[4];
        strncpy(to, "dog\0", 4);
        // strncpy(to, msg_to_store->to, 4);

    datum my_key;
        my_key.dptr = to;
        my_key.dsize = 3;

    datum my_value;
    printf("Querying my_db for key '%s'...\n", my_key.dptr);

    my_value = gdbm_fetch(my_db, my_key);
    printf("\nmy_value.dptr:\t%s\n", my_value.dptr);

    static int  error_code;     /* Error code for PUT operation */
    return &error_code;
}

message *tims_get_1_svc(name *to, struct svc_req *rqstp)  {
    static message  outgoing_msg;
    return &outgoing_msg;
}

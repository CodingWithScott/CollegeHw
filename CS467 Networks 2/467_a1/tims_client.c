/*
 *	 		TIMS:	Totally Insecure Messaging System
 * 
 *		This client accepts user input for the relevant fields, and does message
 *		requests to the server using rpc functions. 
 */

#include "tims.h"			/* rpc generated master header file */
#include <strings.h>		/* Case insensitive string comparison. strcasecmp(3) */
#include <time.h> 			/* Printing timestamps. ctime(3) */



/* Print a message struct to screen */
void print_message(message msg) {
	/* Stuff for storing/displaying timestamp info. See strftime(3). */
	const int 	MAX_TIME_SIZE = 50;
	char 		time_str[MAX_TIME_SIZE];
	struct 		tm *tmp;

	time_t epoch = msg.datetime;
	tmp = localtime(&epoch);

	printf("To:\t%s\n", msg.to);
	printf("From:\t%s\n", msg.from);
	printf("Time:\t");
	strftime(time_str, MAX_TIME_SIZE, "%a %b %e %H:%M:%S %Y", tmp);
	printf("%s\n", time_str);
	printf("Body:\t%s\n", msg.body);
} 




void tims_prog_1(char *host, char* send_mode, name to, name from, char* body) {
	CLIENT *clnt;			/* Client data generated to send with rpc function */
	int  *put_error_code;	/* Error return value from tims_get_1().
							   Formerly known as result_1. 			*/
	message  outgoing_msg;	/* Message to be sent to server via PUT. 
							   Formerly known as tims_put_1_arg. 	*/
	message  *incoming_msg;	/* Message being downloaded from the server via GET. 
							   Formerly known as *result_2;			*/ 
	name  my_name;			/* Name being sent to server in GET request. */

	#ifndef	DEBUG
		clnt = clnt_create (host, TIMS_PROG, TIMS_VERS, "udp");
		if (clnt == NULL) {
			clnt_pcreateerror (host);
			exit (1);
		}
	#endif	/* DEBUG */

	/* Calling PUT function */
	if (!strcasecmp(send_mode, "PUT")) {
		/* Build message before sending out */
		strncpy(outgoing_msg.to, to, NAME_LEN);
		strncpy(outgoing_msg.from, from, NAME_LEN);
		outgoing_msg.datetime = 0;	/* Server assigns this */
		strncpy(outgoing_msg.body, body, MSG_LEN);



		printf("\nOutgoing message:\n================================\n");
		print_message(outgoing_msg);


		put_error_code = tims_put_1(&outgoing_msg, clnt);
		// if (put_error_code == (int *) NULL) 
		printf("DEBUG:\n");
		printf("\terror_code:\t%d\n", (int) put_error_code);
		if (put_error_code == (int *) NULL) {
			clnt_perror (clnt, "\nMessage send failure!\n");
			return;
		}
		else
			printf("\nMessage sent.\n");
	}
	/* Calling GET function */
	else if (!strcasecmp(send_mode, "GET")) {
		printf("Client placeholder for GETting a message\n");
		
		// strncpy(my_name, to, NAME_LEN);
		my_name = to;

		incoming_msg = tims_get_1(&my_name, clnt);
		if (incoming_msg == (message *) NULL) {
			clnt_perror (clnt, "\nMessage receive failure!"); 
			return;
		}

		printf("Server sent the following message:\n");
		print_message(*incoming_msg);
	}

	#ifndef	DEBUG
		clnt_destroy (clnt);
	#endif	 /* DEBUG */
}


int main (int argc, char *argv[]){
	char *host = argv[1];
	char *send_mode = argv[2];
	char *to = argv[3];
	char *from = argv[4];
	char *body = argv[5];


	/* PUT mode */
	if (argc == 6) {
		tims_prog_1(host, send_mode, to, from, body);
	}
	/* GET mode */
	else if (argc == 4) {
		printf("GETting for user %s\n", to);
		tims_prog_1(host, send_mode, to, "", "");

	}
	/* Janky input */
	else if (argc < 2) {
		printf ("usage: %s server_host send_mode to [from] [body]\n", argv[0]);
		exit (69);
	}

	exit (0);
}

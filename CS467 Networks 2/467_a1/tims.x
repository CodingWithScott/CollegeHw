/* 
 *	Scott Felch
 *	Spring 2015
 *	CSCI 467
 *	Assignment 1: Totally Insecure Messaging System (TIMS) 
 *
 *	An extremely simple mail storage/retrieval system. Utilizes rpc_gen for
 *  client/server communication and gdbm database for message storage.
 *
 * 			Spec file: 
 *	https://github.com/apexskier/csci467s15/blob/master/project1.markdown
 *
 *			Resources:
 *	gdbm:	http://www.vivtek.com/gdbm/api.html 
 *			http://www.vivtek.com/gdbm/example.html 
 *			http://www.gnu.org.ua/software/gdbm/manual//gdbm.html
 *
 * rpcgen:	http://docs.oracle.com/cd/E19683-01/816-1435/rpcgenpguide-21470/index.html
 * 			https://www-01.ibm.com/support/knowledgecenter/ssw_aix_61/com.ibm.aix.commtrf1/clnt_create.htm
 *			http://www.cs.cf.ac.uk/Dave/C/node33.html
 *			http://www.ece.eng.wayne.edu/~gchen/ece5650/lecture9.pdf
 *			http://linux.die.net/man/3/clnt_create
 */


const EPOCH_LEN = 8;
const MIN_BLK_SZE = 512;
const MSG_LEN = 256;
const NAME_LEN = 32;
const STRUCT_LEN = 328;

typedef string name<NAME_LEN>;

struct message {
    char to[NAME_LEN];
    char from[NAME_LEN];
    int datetime;
    char body[MSG_LEN];
};

program TIMS_PROG {
    version TIMS_VERS {
        int TIMS_PUT(message) = 1;
        message TIMS_GET(name) = 2;
    } = 1;
} = 24670117;
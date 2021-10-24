/**************************************************************************************/
/*@filename: sendEmail.sas										    			  */
/* 																	    	 		  */
/*@created: 3/21/12 by Manuel Figallo 										 		  */
/*@updated: Updated 3/22/12 (MF) 													  */
/*@version: Version 0.1 															  */
/* 																			 		  */
/*@description:													 		  			  */
/*		Send an email message specifying recipient, Subject, and email body. 		  */
/*@end 																		 		  */
/* 																			 		  */
/*@output:																 		  	  */
/* 		An email messages			 		 		 		  */
/*@end 																		 		  */
/* 																			 		  */
/*@parameters: 													 		  			  */
/* 		emailSubject - In double quotes, the email subject       					*/
/*		  																	 		  */
/*		emailDest - In double quotes, the destination of the 						  */
/* 				email: e.g., mfigallo@devtechsys.com.  Specify two more recipients 	  */
/*		  		with a comma												 		  */
/*		  																	 		  */
/*		emailMsg - In double quotes, The email message.      		  				  */
/*		  																	 		  */
/*@end 																		 		  */
/* 																			 		  */
/*@limitations: 															 		  */
/*		No attachments are possible												  */
/*@end 																		 		  */
/* 																			 		  */
/*@usage: 														 		  			  */
/*  Example 1: 															 		  	  */
/* %sendEmail(emailSubject="Job Alert: Completed", 								      */
/* emailDest="mfigallo@devtechsys.com", 											   */
/* emailMsg="hello there, This is an email message to test the email alert system. Manuel") */
/* 																			 		  */
/*  Example 2: 															 		  	  */
/* %sendEmail(emailSubject="Job Alert: Completed", 								      */
/* emailDest="mfigallo@devtechsys.com, cdebrey@devtechsys.com",					   */
/* emailMsg="hello there, This is an email message to test the email alert system. Manuel") */
/* 																			 		  */
/*@end 																		 		  */
/* 																			 		  */
/*@macrodependencies:  															 	  */
/* 		None.																		  */
/*@end 																		 		  */
/* 																			 		  */
/*@filedependencies:  															 	  */
/* 		None.																		  */
/*@end 																		 		  */
/**************************************************************************************/

%macro sendEmail(emailSubject=, emailDest=, emailMsg=);

%if &emailSubject= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a Subject.;
	%return; 
%end;
%if &emailDest= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide an email destination.;
	%return; 
%end;
%if &emailMsg= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a message.;
	%return; 
%end;

%put &emailSubject;
%put &emailDest;
%put &emailMsg;

/*
java -classpath "C:\SAS\code\macros\v0_0_1b\java;C:\SAS\code\macros\v0_0_1b\java\jar\mail.jar;C:\SAS\code\macros\v0_0_1b\java\jar\activation.jar;." SendMailSSL "testSub" "manuel.figallo@sas.com" "hello world"

*/
x %unquote(%str(%'java -classpath "C:\SAS\code\macros\v0_0_1b\java;C:\SAS\code\macros\v0_0_1b\java\jar\mail.jar;C:\SAS\code\macros\v0_0_1b\java\jar\activation.jar;." SendMailSSL &emailSubject &emailDest &emailMsg%'));



%mend sendEmail;

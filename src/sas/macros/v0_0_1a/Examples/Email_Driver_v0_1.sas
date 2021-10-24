
/****************************DRIVER TO Email Message*************************/
/*declare sas autos*/
options noxwait mprint mlogic sasautos=(sasautos,"C:\SAS\code\macros\v0_0_1b_DEV\java");

%sendEmail(emailSubject="Your Job is Done", emailDest="manuel.figallo@sas.com", emailMsg="Please review your data results in Visual Analytics")


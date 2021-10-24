options noxwait mprint mlogic sasautos=(sasautos,"C:\SAS\code\macros\v0_0_1b_DEV4");

%let myFilePath="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\OUTPUT_GetTweetsBySearch_v1_1_1_1.csv";
%importData(FilePath=&myFilePath, DSOut=work.test123)


%let myFilePath2="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\OUTTWEETS_61208_543_v1.csv";
%importData(FilePath=&myFilePath2, DSOut=work.test222)


%let myFilePath3="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\OUTTWEETS_62145_716_v1.csv";
%importData(FilePath=&myFilePath3, DSOut=work.test333)

%let myFilePath4="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\OUTTWEETS_31657_293_v1.csv";
%importData(FilePath=&myFilePath4, DSOut=work.test4444)

%let myFilePath4="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\OUTPUT_GetTweetsBySearch_v1_1_5.csv";
%importData(FilePath=&myFilePath4, DSOut=work.test55555)





/**/
data work.test3332;
	set work.test333;
	if (_n_ ge 10) then delete;
run;

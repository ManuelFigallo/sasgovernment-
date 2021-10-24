/****************************************************************************************************/
/*@filename: extractResource.sas										    			  			   	*/
/* 																	    	 		  			   	*/
/*@created: 9/26/11 by Manuel Figallo 										 		  			   	*/
/*@updated: 9/29/11 (MF) 													 		  			   	*/
/*@version: Version 0.1 															  			   	*/
/* 																			 		  			   	*/
/*@description:													 		  			  			   	*/
/*  	Extract Resource from an HTTP location. Files can be CSV, Excel, HTML, XML, 	  			   	*/
/*		or ZIP.  Query strings can also be executed and the results downloaded as 	  			   	*/
/*		an Excel, etc.  When downloading a ZIP be sure to specify BINARY-the default  			   	*/
/*		is TEXT. This macro is inherited by the downloadManyFiles.sas macro	 		  			   	*/
/*@end 																		 		  			   	*/
/* 																			 		  			   	*/
/*@output:																	 		  			   	*/
/* 		Files in an filesystem destination location			 		 		 		  			   	*/
/*@end 																		 		  			   	*/
/* 																			 		  			   	*/
/*@parameters:																 		  			   	*/
/* 		remoteURL (string) - The HTTP source location of a FILE or EXE program.       			   	*/
/*		A query string is required for the latter.									  			   	*/
/*		  																	 		  			   	*/
/*		localFilename (string)  - The filesystem destination location (S:, C:) for the file	  	   	*/
/*		download.									 		  						  			   	*/
/*		  																	 		  			   	*/
/*		TYPE (boolean) - Is the file BINARY?  If so, use this parameter value.  The default is     	*/
/*		transfer type TEXT.									 		  				  			   	*/
/*		  																	 		  			   	*/
/*		proxyName (string) - Name of a proxy server if required								     	*/
/*		  																	 		  			   	*/
/*@end																		 		  			   	*/
/* 																			 		  			   	*/
/*@limitations:  															 		  			   	*/
/* 		Only a the GET method in the HTTP location will work. Future versions will	  			  	*/
/* 		include POST.																  				*/
/*@end 																		 		  				*/
/* 																			 		  				*/
/*@usage: 																	 		  				*/
/* 	Example 1: 															 		  	  				*/
/*	%let myremoteURL1="http://gbk.eads.usaidallnet.gov/data/files/us_economic_assistance.csv"; 		*/
/*	%let mylocalFilename1="C:\xxx\outputs\us_economic_assistance.csv";		 		  				*/
/*	%extractFile(remoteURL=&myremoteURL1, localFilename=&mylocalFilename1)			  				*/
/* 																			 		  				*/
/*	  Example 2: 															 		  				*/
/*	%let myremoteURL3="http://databank.worldbank.org/databank/download/ADI_csv.zip";  				*/
/*	%let mylocalFilename3="C:\xxx\outputs\ADP\ADI_csv3.zip";  						  				*/
/*	%let myType3=BINARY;															  				*/
/*	%extractFile(remoteURL=&myremoteURL3, localFilename=&mylocalFilename3, TYPE=&myType3) 			*/
/*		  																	 		  				*/
/*@end 																		 		  				*/
/****************************************************************************************************/

%macro extractResource(remoteURL=, localFilename=, TYPE=, proxyName=);
%if &remoteURL= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide an HTTP location.;
	%return; 
%end;
%if &localFilename= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide an destination location on your C: drive, S: drive, etc.;
	%return; 
%end;

%if &proxyName ne %then %do;
		%let proxyName2=PROXY=&proxyName;
		%put &proxyName2;
%end;
%else %do;
		%let proxyName2=;
%end;

/*For BINARY files use this code*/
%IF &TYPE=BINARY %THEN %DO;
	FILENAME lcl url &remoteURL recfm=s DEBUG;
	FILENAME rmt &localFilename recfm=n;
	DATA _NULL_;
	   N=1;
	   INFILE lcl NBYTE=n;
	   INPUT;
	   FILE rmt ;
	   PUT _INFILE_ @@; 
	Run;
%END;
/*For a text extraction, try executing the extractFile macro only two times*/
%ELSE %DO i = 1 %to 2;
	filename remote url &remoteURL recfm=V debug &proxyName2;
	/*
PROXY="http://inetgw.unx.sas.com" debug;
	*/
	data _null_;
	nbyte=1;
	infile remote nbyte=nbyte end=done lrecl=999999;
	file &localFilename  lrecl=999999;
	do while (not done);
	 input;
	 put _infile_ @;
	end;
	stop;
	run;
	filename remote clear;
	%if &syserr=0 %then %return;
%END;

%mend extractResource;


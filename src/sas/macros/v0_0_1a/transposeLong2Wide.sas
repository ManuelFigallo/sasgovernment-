/**************************************************************************************/
/*@filename: transposeLong2Wide.sas										    			  	  */
/* 																	    	 		  */
/*@created: 9/26/11 by Manuel Figallo 										 		  */
/*@updated: Updated 11/22/11 (MF) 													  */
/*@version: Version 0.1 															  */
/* 																			 		  */
/*@description:													 		  			  */
/*		Transpose a dataset long to wide.	  										  */
/*@end 																		 		  */
/* 																			 		  */
/*@output:																 		  	  */
/* 		A sas7bdat file		 		 		  										  */
/*@end 																		 		  */
/* 																			 		  */
/*@parameters: 													 		  			  */
/* 		DSIn - Name of Input DS										          		  */
/* 		DSOut - Name of Output DS											          */
/* 		StaticVarsList - List of Variables that remain static						  */
/* 		NewVarsListCol - After a transpose, this long variable will become columns	  */
/* 		NewVarsListRow - After a transpose, this long variable will become rows		  */
/*		  																	 		  */
/*@end 																		 		  */
/* 																			 		  */
/*@limitations: 															 		  */
/*		Requires some knowledge of how tranpose works since error checking is minimal */
/*@end 																		 		  */
/* 																			 		  */
/*@usage: 														 		  			  */
/*  Example 1: 															 		  	  */
/*	%let myDS2Trans=work.wb_data_s2;	  											  */
/*	%let myDSTrans=work.wb_data_s2L2W;	  											  */
/*	%let myStaticVarArray=Region*Country*Year;	   									  */
/*	%let myNewVarListCol=Indicator;	  												  */
/*	%let myNewVarListRow=Value;	  													  */
/*	%transposeLong2Wide(DSIn=&myDS2Trans, DSOut=&myDSTrans,	  						  */ 
/*		StaticVarsList=&myStaticVarArray, NewVarsListCol=&myNewVarListCol,	  		  */ 
/*		NewVarsListRow=&myNewVarListRow)	  										  */
/*		  																	 		  */
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
%macro transposeLong2Wide(DSIn=, DSOut=, StaticVarsList=, NewVarsListCol=, NewVarsListRow=);

%if &DSIn= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a SAS Dataset name as input.;
	%return; 
%end;

%if &DSOut= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a SAS Dataset name for output.;
	%return; 
%end;
%if &NewVarsListCol= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide where to get column names after a tranpose.;
	%return; 
%end;

%if &NewVarsListRow= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide where to get values after a tranpose.;
	%return; 
%end;


/*list all items in a list with a blank space in between*/
%let thisStaticVarsListBlank=%sysfunc(tranwrd(&StaticVarsList,*, %str()));   
%put &thisStaticVarsListBlank;

proc sort data=&DSIn out=&DSIn;
	by &thisStaticVarsListBlank;
run;

proc transpose data=&DSIn out=&DSOut;
	id &NewVarsListCol;
	var &NewVarsListRow;
	by &thisStaticVarsListBlank;
run;

data &DSOut(drop=_NAME_);
	set &DSOut;
run;

%mend transposeLong2Wide;

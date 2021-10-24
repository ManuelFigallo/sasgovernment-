
%macro importData(Sheet, XMLRoot=, FilePath=, DSOut=);

%put &Sheet;
%if &Sheet eq %then %do;
	%LET Sheet="Sheet1";
%end;
%put &Sheet;
%let thisFilePath=%sysfunc(compress(&FilePath, '"'));
%put &thisFilePath;
%LET extension=%SYSFUNC(scan(&thisFilePath,-1,'.'));
%put &extension;

%IF &extension=csv %THEN %DO;
	PROC IMPORT OUT=&DSOut DATAFILE=&FilePath
	DBMS=CSV REPLACE; 
	GETNAMES=YES; 
	DATAROW=2;
	GUESSINGROWS=30000;
	RUN;
%END;
%IF &extension=xls OR &extension=xlsx %THEN %DO;
	%let this_DSOUT=&DSOut;
	%let this_DSOUTtmp=%sysfunc(catt(&DSOut,tmp));


	PROC IMPORT OUT=&this_DSOUTtmp  DATAFILE= &FilePath 
	            DBMS=&extension REPLACE;
	     SHEET=&Sheet; 
	     GETNAMES=YES;
		 *MIXED=YES;
		 *GUESSINGROWS=30000;
	RUN;


	%macro getVarList(DSIn=);
	ods listing close;
	ods output Contents.DataSet.Variables=work.varlist;

	proc contents data=&DSIn; 
	run;

	ods output close;
	ods listing;
	%mend getVarList;


	%getVarList(DSIn=&this_DSOUTtmp)
	proc sql noprint;
		select Variable into :thisvar
		from work.varlist
		where Num=1;
	quit;
	proc sql;
	create table &this_DSOUT as
		select *
		from &this_DSOUTtmp
		where &thisvar IS NOT NULL 
	;
	quit;
%deleteDSN(&this_DSOUTtmp)


%END;
%IF &extension=xml %THEN %DO;

	%if &XMLRoot eq %then %do;
		%LET XMLRoot="ROOT";
	%end;
	%put &XMLRoot;
	%put &XMLRoot;

	libname this_xml xml %unquote(%str(%'&FilePath%')) ;

	data &DSOut;
	   set this_xml.&XMLRoot;
	run;

%END;
%IF &extension=txt %THEN %DO;
		proc import datafile=%unquote(%str(%'&FilePath%'))
		     out=&DSOut
		     dbms=dlm
		     replace;
		     delimiter='09'x;
			 getnames=no;
		     datarow=1;
		run;

%END;
%ELSE %DO;
	%put 'Nothing Here';
%END;
%mend importData;

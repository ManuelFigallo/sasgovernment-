
%macro loadDS2LASR(MetaSrvConfig=, LASRSrvConfig=, SrcDS=, SrcPath=, SrcLib=, SrcLibFolderPath=, TargetLib=, TargetLibFolderPath=);

%if &MetaSrvConfig=default %then %do;
	%put Default Values for MetaServer will be assigned;
	%let MetaDataSrvHost=sasva.demo.sas.com;
	%let MetaDataSrvPort=8561;
	%let MetaDataSrvUser=sasdemo;
	%let MetaDataSrvPw=Orion123;
%end;
%else %if &MetaSrvConfig=raceEEC100 %then %do;
	%put RACE Default Values for MetaServer will be assigned;
	%let MetaDataSrvHost=sasva.demo.sas.com;
	%let MetaDataSrvPort=8561;
	%let MetaDataSrvUser=sasadm@saspw;
	%let MetaDataSrvPw=Orion123;
%end;
%else %do;
	%put Default Values for MetaSrvConfig will be assigned;
	%let MetaDataSrvHost=sasva.demo.sas.com;
	%let MetaDataSrvPort=8561;
	%let MetaDataSrvUser=sasdemo;
	%let MetaDataSrvPw=Orion123;
%end;

%if &LASRSrvConfig=default %then %do;
	%put Default Values for LASRSrvConfig will be assigned;
	%let TargetServer=sasva.demo.sas.com;
	%let TargetServerPort=10031;
	%let TargetServerTag=HPS;
%end;
%if &LASRSrvConfig=raceEEC100_2 %then %do;
	%put Default Values for LASRSrvConfig 2 will be assigned;
	%put Default Values for LASRSrvConfig 2 will be assigned;
	%put Default Values for LASRSrvConfig 2 will be assigned;
	%let TargetServer=sasva.demo.sas.com;
	%let TargetServerPort=10011;
	%let TargetServerTag=PUBLIC;
%end;
%if &LASRSrvConfig=raceEEC100 %then %do;
	%put RACE Default Values for LASRSrvConfig will be assigned;
	%let TargetServer=sasva.demo.sas.com;
	%let TargetServerPort=10031;
	%let TargetServerTag=PUBLIC;
%end;
%if &LASRSrvConfig=default %then %do;
	%put RACE Default Values for LASRSrvConfig will be assigned;
	%let TargetServer=sasva.demo.sas.com;
	%let TargetServerPort=10031;
	%let TargetServerTag=HPS;
%end;
%else %do;
	%put Default Values for LASRSrvConfig will be assigned;
	%let TargetServer=sasva.demo.sas.com;
	%let TargetServerPort=10031;
	%let TargetServerTag=HPS;
%end;

%if &SrcDS= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a valid Source Data Name.;
	%return; 
%end;
%if &SrcPath= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a valid Source Path.;
	%return; 
%end;
%if &SrcLib= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a valid Source Library.;
	%return; 
%end;
%if &SrcLibFolderPath= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a valid Source Library Folder Path.;
	%return; 
%end;
%if &TargetLib= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a valid Target Library.;
	%return; 
%end;
%if &TargetLibFolderPath= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a valid Target Library Path.;
	%return; 
%end;

Options metaserver="&MetaDataSrvHost"   		/** metaserver="sasva.unx.sas.com" **/ 
    metaport=&MetaDataSrvPort 
    metauser="&MetaDataSrvUser"       			/** or "sasdemo" or "sasadm@saspw"  **/
    metapass=&MetaDataSrvPw 
    metarepository="Foundation" 
    metaprotocol=BRIDGE;

%macro chooseUpdateOrAdd;
	%global this_AddOrUpdate;

	%if %sysfunc(exist(&SrcLib..&SrcDS.)) %then %do;
		%put "UPDATING........";
		%let this_AddOrUpdate=noadd;
	%end;
	%else %do;
		%put "ADDING........";
		%let this_AddOrUpdate=NOUPDATE;
	%end;

%mend chooseUpdateOrAdd;

%chooseUpdateOrAdd;

%put &this_AddOrUpdate;
%put The proc metalib var will be %trim(&this_AddOrUpdate) and is global;


%put The follwoing source library will be used: &SrcLib;
%put The follwoing source library will be used: &SrcLib;
%put The follwoing source library will be used: &SrcLib;
%put The follwoing source library will be used: &SrcLib;

Proc Metalib TL=4095;
	omr (library="&SrcLib");		/** Libname where the data is to be registered  **/
	
	/** Use this to ADD a new metadata registration for a table **/
	update_rule=(&this_AddOrUpdate);
	*report(type=detail);
	folder=&SrcLibFolderPath;		/** Location of the libname **/	
	select=("&SrcDS");		/** Use to register a single table, omit when updating table(s) in folder **/
run;


/*******************************************************************
***  Load the dataset(s) into memory (LASR Server)  ***
*******************************************************************/
  /*LASR SERVER MUST BE RUNNING - PORT NUMBER CORRESPONDS TO SERVER COMPONENT!!!!*/
  /*TODO: research if libname sasiola can be replaced by PROC LASR for SMP and MPP environments*/
 Libname LsrSrvr sasiola TAG=&TargetServerTag port=&TargetServerPort HOST="&TargetServer";   /** "localhost" OR "sasva.demo.sas.com";  **/
 Libname MyLsrLib BASE &SrcPath;	  /**  folder where physical dataset resides  **/



%macro deleteLASRIfExists(lib,name);
%if %sysfunc(exist(&lib..&name.)) %then %do;
	proc datasets library=&lib. nolist;
	delete &name.;
	quit;
%end;
%mend;

%let this_lib=LsrSrvr;
%let this_name=&SrcDS;
%deleteLASRIfExists(&this_lib,&this_name)


 Data LsrSrvr.&SrcDS;	/** MUST use Datastep with SMP LASR server. But, can be used with MPP or SMP **/
    Set MyLsrLib.&SrcDS;	/** Can do A LOT of other SAS within the datastep (where, if, etc).   **/
 run;




 /******************************************************
***  Register the LASR file(s) in Metadata  TEST 2***
******************************************************/

Proc Metalib;
   omr (library=&TargetLib);
    update_rule=(&this_AddOrUpdate); 
    *report(type=summary); 
    folder=&TargetLibFolderPath ;
    select=("&SrcDS");
 run;

%mend loadDS2LASR;


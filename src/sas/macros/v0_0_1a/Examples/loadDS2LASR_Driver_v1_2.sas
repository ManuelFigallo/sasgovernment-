
/******************************DRIVER TO Load ds*************************/
/*declare sas autos*/
options noxwait mprint mlogic sasautos=(sasautos,"C:\SAS\code\macros\v0_0_1b\");
%let MySrcDataSet=crime_table1;
%let MySrcDataSetPath="C:\Temp\temp1";
%let MySrcLibrary=temp1;
%let MySrcLibraryFolderPath="/Shared Data/TEMP1";
%let MyTargetLib="Visual Analytics Public LASR";
%let MyTargetLibFolder="/Shared Data/SAS Visual Analytics/Public/LASR/ALL_LABS/LAB_NAME_1";
/*
/Shared Data/SAS Visual Analytics/Public/LASR/ALL_LABS/LAB_NAME_1
/Shared Data/SAS Visual Analytics/Public/LASR/ALL_LABS/LAB_NAME_2
*/
%loadDS2LASR(SrcDS=&MySrcDataSet, SrcPath=&MySrcDataSetPath, SrcLib=&MySrcLibrary, SrcLibFolderPath=&MySrcLibraryFolderPath, TargetLib=&MyTargetLib, TargetLibFolderPath=&MyTargetLibFolder)

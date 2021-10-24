/*!
* <B>Description:</B> Delete all files from a specified folder.
* <BR>
* <BR>
* <B>Last Updated:</b> 06/27/2013 (MF)<br><br>
* <B>Version:</b> 0_0_1b<br><br>
* @author Manuel Figallo
* @created 06/12/2013
*/
/**
* <B>Usage:</B><BR><br> 
* Example 1: <BR>
* %let myOutFldr="C:\Users\mafiga\Desktop\SAS Content Cat\BLS\data\trainingtest"; <br> 
* %deleteAllFiles(Folder=&myOutFldr)  
* <BR>
* <B>Limitations:</B><BR> This will only work in an MS-DOS environment
* <BR>
* <B>Future Enhancements:</B><BR> TBD
* <BR>
* @param Folder (string) Fullpath location of a folder from which to delete all files
* @return NULL.
* <BR>
* <B>Datasets:</B> NULL.
* <BR>
* <B>Macro Vars:</B> NULL.
*/
%macro deleteAllFiles(Folder=);

options noxwait;

		%if &Folder= %then %do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide a full path location for a folder from which all files will be removed.;
			%return; 
		%end;

		%let thisFolder=%sysfunc(compress(&Folder, '"'));

		x "cd &thisFolder";
		x "del *.* /Q";


%mend deleteAllFiles;



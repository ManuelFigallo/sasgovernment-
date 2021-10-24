/****************************************************************************************************/
/*@filename: transformXML2SAS.sas									    			  			   	*/
/* 																	    	 		  			   	*/
/*@created: 9/26/11 by Manuel Figallo 										 		  			   	*/
/*@updated: 9/29/11 (MF) 													 		  			   	*/
/*@version: Version 0.1 															  			   	*/
/* 																			 		  			   	*/
/*@description:													 		  			  			   	*/
/*  	Transform XML files using an XML map into a SAS dataset. 	  			   					*/
/*@end 																		 		  			   	*/
/* 																			 		  			   	*/
/*@output:																	 		  			   	*/
/* 		SAS datasets named according to SAS conventions and using the XML file name to the greatest	*/
/* 		extent possible.													 		  			   	*/
/*@end 																		 		  			   	*/
/* 																			 		  			   	*/
/*@parameters:																 		  			   	*/
/* 		LocalXML (string) - The full path to the XML file.       			   						*/
/*		  																	 		  			   	*/
/*		XMLMap (string)  - The XML Map to convert the XML file.	  	   								*/
/*		  																	 		  			   	*/
/*		DSOut (string) - The name of the Dataset as output.  It must follow SAS conventions.		*/
/*		  																	 		  			   	*/
/*@end																		 		  			   	*/
/* 																			 		  			   	*/
/*@limitations:  															 		  			   	*/
/* 		This macro requires an XML Map.  Use the importData macro to download simple XML files	  	*/
/* 		that do not require a MAP.													  				*/
/*@end 																		 		  				*/
/* 																			 		  				*/
/*@usage: 																	 		  				*/
/* 	Example 1: 															 		  	  				*/
/*	%let myLocal="C:\xxx\SAS Global Forum\outputs\SP.DYN.TFRT.IN.xml";								*/
/*	%let myMap="C:\xxx\SAS Global Forum\inputs\wdi_v3.map";											*/
/*	%let myDSOut=work.SP_DYN_TFRT_IN;																*/
/*	%transformXML2SAS(LocalXML=&myLocal, XMLMap=&myMap, DSOut=&myDSOut)								*/	
/*@end 																		 		  				*/
/****************************************************************************************************/


%macro transformXML2SAS(LocalXML=, XMLMap=, DSOut=);
/*xml_root_tmp will scan the MAP file for the name of the ROOT node, used in the set statement
when the SAS dataset is created*/
	data xml_root_tmp;
		infile &XMLMap truncover end=done;
		input col1 $200.;
		length filen $20;
		filen=compress(filen,'09'x);
		if col1 =: "<TABLE name=" then filen=strip(translate(strip(scan(col1,2,'=')),'','">'));
		if done then output;
		retain filen;
		drop col1;
		call symputx('r_tbl_name',trim(filen),'G');
	run;

	%put &r_tbl_name;
	%put &r_tbl_name;
	%put &r_tbl_name;
	%put &r_tbl_name;

	%put &LocalXML;
	%put &LocalXML;
	%put &LocalXML;
	%put &LocalXML;

	%put &XMLMap;
	%put &XMLMap;
	%put &XMLMap;
	%put &XMLMap;


	filename  XML_FN &LocalXML;
	filename  MAP_FN &XMLMap;
	libname   XML_FN xml xmlmap=MAP_FN access=READONLY;

	data &DSOut;
		set XML_FN.&r_tbl_name;
	run;
%mend;

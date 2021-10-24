/**************************************************************************************/
/*@filename: parseJSON.sas										    			  	  */
/* 																	    	 		  */
/*@created: 11/17/13 by Manuel Figallo 										 		  */
/*@updated: Updated 1/2/14 (MF) 													  */
/*@version: Version 0.1 															  */
/* 																			 		  */
/*@description:													 		  			  */
/*		Parse a JSON File									 	  					  */
/*@end 																		 		  */
/* 																			 		  */
/*@output:																 		  	  */
/* 		A dataset named JSON				 		 		 		  				  */
/*@end 																		 		  */
/* 																			 		  */
/*@parameters: 													 		  			  */
/* 		Fname - The Name of the JSON file to be parsed.     	 					  */
/*		  																	 		  */
/*		varList - The variables to parse (using an array notation)			  		  */
/*									 		  						  				  */
/*		<DSOUT> - The dataset output name			  								  */
/*									 		  						  				  */
/*		<TYPE> -  The JSON file format can be regular or irregular			  		  */
/*									 		  						  				  */
/*@end 																		 		  */
/* 																			 		  */
/*@limitations: 															 		  */
/* 	Only a JSON dataset is created 	in this version  								  */
/*@end 																		 		  */
/* 																			 		  */
/*@usage: 														 		  			  */
/*  Example 1: 															 		  	  */
/*%parseJSON(Fname="S:\xxx\pingdom.json", varList=id*created*name);					  */
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

%macro parseJSON(Fname=, varList=, DSOUT=, TYPE=);    

%if &TYPE eq %then %do;
	%LET TYPE=regular;
%end;
%if &DSOUT eq %then %do;
	%LET DSOUT=work.json_out;
%end;
%if &Fname= %then %do;
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide full filename path of the JSON file to be parsed.;
	%return; 
%end;
/*check &varList which needs to be masked because of asterik.  I can use %str() to mask the variable to create a character at compile time.  Or, use 
%bquote(&paramname) if it's execution time.  
*/
%if %sysfunc(tranwrd(&varList,*,%str( ))) eq %then %do;
	/*
	%put ERROR: A null value is not valid.;
	%put ERROR- Please provide a list of variables to parse using an array notation standard--i.e., * delimiter.;
	%return; 
	*/
	%IF &TYPE=irregular %THEN %DO;
				/*IRREGULAR HEADER PARSER GOES HERE*/
				data s1;
						FILENAME thisFN1 &Fname;
						infile thisFN1 dsd dlmstr='],[' truncover lrecl=4096 obs=1 end=done;
						input header1 $800.;
						header2=compress(tranwrd(header1,'","','*'),'"[],');
						call symput('varList', header2);
				run;
				%put &varList;
	%END;
	%ELSE %DO;
				/*REGULAR HEADER PARSER GOES HERE*/			
				data s1;
					FILENAME thisFN1 &Fname;
					infile thisFN1;                                                                                                                             
					input;    
					header2 = _INFILE_;   
					total=count(header2, ",")+1;      
					call symput('this_header3', substr(header2, find(header2,'[{'), (find(header2,'}]')-find(header2,'[{'))));
				run;
				%put &this_header3;
				PROC SQL NOPRINT;
					SELECT total
					INTO :my_total
					FROM s1;
				QUIT;
				%put &my_total;                                                                                                                                                                                                                                                                                                                                                                                                                                          
				data s2;   
					array varArray(&my_total) $ 300;                         
					do i=1 to dim(vararray);                                                                                                                                                                                                
				                  varArray{i}=compress(scan(scan(%unquote(%str(%'&this_header3%')), i, ","), 1, ":"), '[{"');                                                                                                                                     
				                  if i=1 then fin_header1=catt(varArray{1}, '*');                                                                                                                                                       
				                  else if i>1 and i<&my_total then fin_header1=catt(fin_header1, varArray{i}, '*');                                                                                                                            
				                  else fin_header1=catt(fin_header1, varArray(i));                                                                                                                                                      
				    end;        
					call symput('varList', fin_header1);
				run;                                                                                                                                                                                                          
				%put &varList;
	%END;	             
%end;


%put &Fname;
%put &varList;
%put &DSOUT;
%put &TYPE;

%IF &TYPE=irregular %THEN %DO;	 
			%let varList2=%sysfunc(tranwrd(&varList,*,%str( )));  
			%let total=%sysfunc(countw(&varList,'*'));
			%put &total;
			data &DSOUT (drop=col1 col2 i);
				array varArray{&total} $ 300 &varList2;
					infile &Fname dsd dlmstr='],[' truncover lrecl=4096 firstobs=2 end=done;
					input col1 $800.;
					col2=compress(tranwrd(col1,'","','#'),'"[]');
					do i=1 to &total;
						if i=&total then varArray{i}=compress(scan(col2,i,'#'),',');                                                                                  
			    		else varArray(i)=scan(col2,i,'#'); 
				    end;
/*
					do i=1 to &total;
						varArray{i}=compress(scan(col1, i, ','), '["]');
				    end;
*/
			run;
%END;
%ELSE %DO;
			%put 'regular json is the default';
			FILENAME thisFN &Fname;                                                                                                                        
			%let varList2=%sysfunc(tranwrd(&varList,*,%str( )));                                                                                            
			data &DSOUT(keep=record &varlist2);                                                                                                        
			    infile thisFN ;                                                                                                                             
			    input;                                                                                                                                      
			    ExpressionID = prxparse('/{(.*?)}/');                                                                                                       
			    jsontext = _INFILE_;                                                                                                                        
			    start = 1;                                                                                                                                  
			    stop = length(jsontext);                                                                                                                    
			    array vlist $50 &varList2;                                                                                                                  
			   call prxnext(ExpressionID, start, stop, jsontext, position, length);                                                                         
			    do while (position > 0);                                                                                                                    
			        newpos = position + 1;                                                                                                                  
			        newlen = length - 2;                                                                                                                    
			        record = substr(jsontext, newpos, newlen);                                                                                              
			        i=0;                                                                                                                                    
			        do over vlist;                                                                                                                          
			            i+1;                                                                                                                                
			            vlist = strip(compress(scan(scan( record, i, ","), -1, ":"), '"'));                                                                  
			        end;                                                                                                                                    
			        output;                                                                                                                                 
			        call prxnext(ExpressionID, start, stop, jsontext, position, length);                                                                    
			    end;                                                                                                                                        
			run;         
%END;
 
%mend;   

/*sasautos defines the location of all macros*/
options mprint mlogic sasautos=(sasautos,"C:\SAS\code\macros\v0_0_1a");

libname json_ds "C:\SAS\code\macros\v0_0_1a\Examples\data";



/*REGULAR JSON FILES*/
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\pingdom.json", varList=id*created*name*hostname*resolution*type*lasterrortime*lasttesttime*lastresponsetime*status);
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\pingdom.json", varList=id*created*name*hostname*resolution*type*lasterrortime*lasttesttime*lastresponsetime*status, DSOUT=work.test1);
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\pingdom.json", varList=id*created*name*hostname*resolution*type*lasterrortime*lasttesttime*lastresponsetime*status, DSOUT=json_ds.test1);

/*CENSUS JSON FILES*/
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\sf1.json", varList=P0010001*NAME*state, DSOUT=work.test2, TYPE=irregular);
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\acs5.json", varList=B25070_003E*NAME*state*county, DSOUT=work.test3_0, TYPE=irregular);

%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\acs5.json", varList=B25070_003E*NAME*state*county, DSOUT=work.test3, TYPE=irregular);
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\acs5.json", varList=B25070_003E*NAME*state*county*testvar, DSOUT=work.test3_1, TYPE=irregular);
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\acs5.json", varList=B25070_003E*NAME*state*county, DSOUT=test4, TYPE=irregular);


/*NO HEADER INFORMATION*/
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\pingdom.json");
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\sf1.json", TYPE=irregular);


%parseJSON(Fname="C:\SAS\code\macros\v0_0_1a\Examples\data\sf1.json", DSOUT=work.test2, TYPE=irregular);



/*NO HEADER INFORMATION 
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\java\hiw\output\hiw_test1.json");
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\java\hiw\output\hiw_test1.json", TYPE=irregular);
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\sf1.json", DSOUT=work.test2, TYPE=irregular);
2*/



/*GSON*/
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\java\gson\single_review1.json", TYPE=irregular);


%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\java\gson\single_review1.json");



/*start TEST ERRORS*/
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\pingdom.json");
%parseJSON(varList=id*created*name*hostname*resolution*type*lasterrortime*lasttesttime*lastresponsetime*status);
%parseJSON(Fname="C:\SAS\code\macros\v0_0_1b_DEV4\Examples\data\acs5.json", varList=B25070_003E*NAME*state*county*testvar*testvar2, DSOUT=work.test3_1, TYPE=irregular);
/*END TEST ERRORS*/

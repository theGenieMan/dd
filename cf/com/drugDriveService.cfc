<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="drugDriveService">
		<cfargument name="dsn" type="string" hint="datasource of drug drive database" required="true" />
		<cfargument name="templateFile" type="string" hint="dft base pdf file to send work off" required="true" />
		<cfargument name="dbToPdfLookupFile" type="string" hint="lookup file to map database to pdf" required="true" />
		<cfargument name="pdfLocation" type="string" hint="location of where pdfs are written too" required="true" />
		<cfargument name="wmDocLocation" type="string" hint="location of where wm pdfs are written too" required="true" />				
				
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.templateFile = arguments.templateFile />
		<cfset variables.dbToPdfLookupFile = arguments.dbToPdfLookupFile />
		<cfset variables.pdfLocation = arguments.pdfLocation />		
		<cfset variables.wmDocLocation = arguments.wmDocLocation />		
		
		<cfset variables.version="1.0.0.0">    
   	    <cfset variables.dateServiceStarted=DateFormat(now(),"DD-MMM-YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>		
		
		<cfreturn this/>
		
	</cffunction>

	<cffunction name="getDrugDriveJSON" description="Get Drug Drive Test From DB" access="remote" output="false" returntype="struct">
       <cfargument name="DD_ID" required="true" type="numeric" hint="DD_ID to get from DB">
       
       <cfset var qDD="">       
       
       <cfquery name="qDD" datasource="#variables.dsn#">
       	SELECT *
       	FROM   FF_OWNER.DRUG_DRIVE
       	WHERE  WWM_DD_ID=<cfqueryparam value="#arguments.DD_ID#" cfsqltype="cf_sql_numeric" />
       </cfquery>
       
       <cfreturn QueryToStruct(qDD,1)>
       
	</cffunction>

	<cffunction name="getDrugDrive" description="Get Drug Drive Test From DB" access="remote" output="false" returntype="query">
       <cfargument name="DD_ID" required="true" type="numeric" hint="DD_ID to get from DB">
       
       <cfset var qDD="">       
       
       <cfquery name="qDD" datasource="#variables.dsn#">
       	SELECT *
       	FROM   FF_OWNER.DRUG_DRIVE
       	WHERE  WWM_DD_ID=<cfqueryparam value="#arguments.DD_ID#" cfsqltype="cf_sql_numeric" />
       </cfquery>
       
       <cfreturn qDD>
       
	</cffunction>

	<cffunction name="createDrugDrive" description="Creates / Updates a Drug Drive Form" access="remote" output="false" returntype="struct">       
       <cfargument name="incomingData" required="true" type="any" hint="drug drive json data to insert/update">
              
       <cfset var qDD="">
       <cfset var qNextSeq="">
       <cfset var formData=structNew()>
       <cfset var returnStruct=structNew()>
       <cfset var qDbToPdfLookup=getDbtoPdfLookup(lookupFile=variables.dbToPdfLookupFile)>
       <cfset var columnName=''>
       <cfset var colValue=''>
       <cfset var iCol=''>
       <cfset var updateQuery=''>
       <cfset var inserQuery=''>
              
       <cfset structAppend( formData, deserializeJson( incomingData ) )>
       
       <cfsavecontent variable="stringFormData"><cfdump var="#formData#" format="text"/></cfsavecontent>
       
       <cflog file="ddService" type="information" text="================================================" >	
	   <cflog file="ddService" type="information" text="create new DD" >
	   <cflog file="ddService" type="information" text="form data" >
	   <cflog file="ddService" type="information" text="#stringFormData#" >
	   <cflog file="ddService" type="information" text="================================================" >
       
       <!--- no DD_ID so it's create a new record time --->
       <cfif not StructKeyExists(formData,'WWM_DD_ID')>
       	  <cfquery name="qNextSeq" datasource="#variables.dsn#">
       	  	select DD_ID_SEQ.NEXTVAL AS NEW_DD_ID from DUAL
       	  </cfquery>
       	  
       	  <cfset formData.WWM_DD_ID=qNextSeq.NEW_DD_ID>
			  
       	  <cfoutput>
       	  <cfsavecontent variable="insertQuery">
       	  	INSERT INTO DRUG_DRIVE
       	  	(
       	  		<cfset iCol=1>
       	  		<cfloop query="qDbToPdfLookup">
				
				 <cfif structKeyExists(formData,DB_NAME)>	 						 	
	       	  		 <cfif iCol GT 1>
	       	  		 ,
	       	  		 </cfif>
	       	  		 #DB_NAME#
	       	  		 <cfset iCol++>
				 </cfif>
       	  		</cfloop>
       	  		,WWM_YEAR       	  		
       	  	)
       	  	VALUES
       	  	(
       	  	    <cfset iCol=1>
       	  		<cfloop query="qDbToPdfLookup">				
				 <cfif structKeyExists(formData,DB_NAME)>	 						 	
	       	  		 <cfif iCol GT 1>
	       	  		 ,
	       	  		 </cfif>
	       	  		 <cfif FIELD_TYPE IS "Date">
					  TO_DATE('#formData[DB_NAME]#','DD/MM/YYYY')	
					 <cfelseif FIELD_TYPE IS "Number">
					   #formData[DB_NAME]#	   	  
					 <cfelse>
					  <cfif isArray(formData[DB_NAME])>
					  	<cfset listOfArray=''>
						<cfloop from="1" to="#arrayLen(formData[DB_NAME])#" index="iArr">
							<cfset listOfArray=ListAppend(listOfArray,formData[DB_NAME][iArr],",")>
						</cfloop> 					  	  
	       	  		  '#listOfArray#'
					  <cfelse>
					  '#formData[DB_NAME]#'	  
					  </cfif>
					 </cfif>
	       	  		 <cfset iCol++>
				 </cfif>
       	  		</cfloop>
       	  		,TO_CHAR(SYSDATE,'YY')       	  		
       	  	)
       	  </cfsavecontent>
       	  </cfoutput>
       	  
       	  <cflog file="ddService" type="information" text="#insertQuery#" >
       	  
       	  <!--- insert the record --->
       	  <cfquery name="qDD" datasource="#variables.dsn#">
       	  	#PreserveSingleQuotes(insertQuery)#
       	  </cfquery>
       	  
       <cfelse>
       <!--- DD_ID exists so we have an update --->
       
	       <cfoutput>
	       	  <cfsavecontent variable="updateQuery">
	       	  	UPDATE DRUG_DRIVE
	       	  	SET
	       	  	<cfset iCol=1>
       	  		<cfloop query="qDbToPdfLookup">				
				 <cfif structKeyExists(formData,DB_NAME) AND DB_NAME IS NOT "WWM_DD_ID">	 						 	
	       	  		 <cfif iCol GT 1>
	       	  		 ,
	       	  		 </cfif>
	       	  		 #DB_NAME# = 
	       	  		 <cfif FIELD_TYPE IS "Date">
					  TO_DATE('#formData[DB_NAME]#','DD/MM/YYYY')	
					 <cfelseif FIELD_TYPE IS "Number">
					   #formData[DB_NAME]#	   	  
					 <cfelse>
	       	  		  <cfif isArray(formData[DB_NAME])>
					  	<cfset listOfArray=''>
						<cfloop from="1" to="#arrayLen(formData[DB_NAME])#" index="iArr">
							<cfset listOfArray=ListAppend(listOfArray,formData[DB_NAME][iArr],",")>
						</cfloop> 					  	  
	       	  		  '#listOfArray#'
					  <cfelse>
					  '#formData[DB_NAME]#'	  
					  </cfif>
					 </cfif>
	       	  		 <cfset iCol++>
				 </cfif>
       	  		</cfloop>       
	       	  	WHERE WWM_DD_ID = #formData['WWM_DD_ID']#	       	  			       	  	
	       	  </cfsavecontent>
	       	  </cfoutput>
          <cflog file="ddService" type="information" text="#updateQuery#" >
          <!--- update the record --->
       	  <cfquery name="qDD" datasource="#variables.dsn#">
       	  	#PreserveSingleQuotes(updateQuery)#
       	  </cfquery>
       
       </cfif>
       
       <cfset returnStruct.DD_ID=formData.WWM_DD_ID>
       
       <cfreturn returnStruct>
       
	</cffunction>

	<cffunction name="finaliseDrugDrive" description="Finalises the drug drive PDF form, returns the URN created" access="remote" output="false" returntype="struct">
		<cfargument name="DD_ID" type="string" required="true" hint="DD_ID of test to finalise" >	

		<cfset var returnStruct=structNew()>
		<cfset var qSeq="">
		<cfset var qUpd="">
		<cfset var qDD=getDrugDrive(arguments.DD_ID)>		
		
		<cfset returnStruct.URN=''>
		
		<cflock timeout="10" scope="Server" type="exclusive">
			
			<cfquery name="qSeq" datasource="#variables.dsn#">
				SELECT MAX(WWM_SERIAL_NO) AS MAX_SERIAL
				FROM   FF_OWNER.DRUG_DRIVE
				WHERE  WWM_YEAR='#qDD.WWM_YEAR#'
				  AND  WWM_TEST_LPA='#qDD.WWM_TEST_LPA#'
				  AND  WWM_TEST_FORCE='#qDD.WWM_TEST_FORCE#'
			</cfquery>
			
			<cfif Len(qSeq.MAX_SERIAL) IS 0>
				<cfset nextSeq=1>
			<cfelse>
			    <cfset nextSeq=qSeq.MAX_SERIAL+1>
			</cfif>
			
			<cfset returnStruct.URN='DRUGDRIVE/'&qDD.WWM_TEST_FORCE&"/"&qDD.WWM_TEST_LPA&"/"&nextSeq&"/"&qDD.WWM_YEAR>
		
			<cfquery name="qUpd" datasource="#variables.dsn#">
				UPDATE FF_OWNER.DRUG_DRIVE
				   SET WWM_SERIAL_NO = #nextSeq#,
				       WWM_URN = '#returnStruct.URN#'
				 WHERE WWM_DD_ID = #qDD.WWM_DD_ID#
			</cfquery>
		
		    <cfset createDrugDrivePDF(qDD.WWM_DD_ID)>
		
		</cflock>
		
     <cfreturn returnStruct>
		
	</cffunction>
	
	<cffunction name="createDrugDrivePDF" description="creates the West Mercia PDF of the Drug Drive record" 
				access="remote" output="false" returntype="void">
		<cfargument name="WWM_DD_ID" type="numeric" required="true" hint="drug drive query to create from">
		
		<cfset var qDrugDrive=getDrugDrive(WWM_DD_ID)>
		<cfset var theDir=variables.wmDocLocation&DateFormat(qDrugDrive.DATE_INITIAL_STOP,"YYYY")&"\">
		<cfset var filename=Replace(qDrugDrive.WWM_URN,"/","_","ALL")&".pdf">
		<cfset var fullFile=theDir&filename>	

		<cfif not directoryExists(theDir)>
		 <cfdirectory action="create" directory="#theDir#">
		</cfif>
				
		<cfloop query="qDrugDrive">
			<cfdocument format="PDF" orientation="portrait" pagetype="A4" margintop="0.75" filename="#fullFile#" overwrite="true">
				<!DOCTYPE html>
				<html>
				<head>
					<style>
						.header {padding:5px; background-color:666666; color:FFFFFF;}
					</style>
				</head>
				<body style="font-family:Arial; font-size:0.8em;">
				
				<br><br>
				<cfoutput>
				<cfdocumentitem type="header">
				 <p align="center" style="font-family:arial; font-size:80%;padding-top:10px;"><strong>RESTRICTED<br>Warwickshire & West Mercia Police - Drug Drive URN : #WWM_URN#</strong></p>
				</cfdocumentitem>
				<cfdocumentitem type="footer">
				<p align="center" style="font-family:arial; font-size:80%">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</p>
				</cfdocumentitem>
				</cfoutput>
				
				<cfoutput>
			    <div style="width:98%; border:1px solid black;">
				 <h3 class="header">Time / Location</h3>        
					<br>
					 <table width="98%" align="center" cellpadding="3" cellspacing="0" style="font-size:100%;">
						<tr>
							 <td width="25%" valign="top"><label style="font-size:130%; font-weight:bold;">URN</label></td>
							 <td class="header">
						       <strong>#WWM_URN#</strong>
							 </td>
						  </tr>	
					    <tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Date/Time</label></td>
						 <td>
						 	#DateFormat(DATE_INITIAL_STOP,"DD/MM/YYYY")# #TIME_INITIAL_STOP#		     
					     </td>
					    </tr>
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">By</label></td>
						 <td>
						 	#WWM_OFFICER_NAME#		     
					     </td>
					    </tr>
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Force / LPA</label></td>
						 <td>
						 	#iif(WWM_TEST_FORCE IS "22",DE("West Mercia (22)"),de("Warwickshire (23)"))# / #WWM_TEST_LPA#		     
					     </td>
					    </tr>
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Beat / Grid Ref</label></td>
						 <td>
						 	<cfif Len(WWM_TEST_BEAT) GT 0>#WWM_TEST_BEAT# /</cfif> #WWM_TEST_GRIDREF#		     
					     </td>
					    </tr>
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Reason</label></td>
						 <td>
						 	#WWM_TEST_REASON#		     
					     </td>
					    </tr>
					 </table>  
			    </div>		
				
			    <br>
				<div style="width:98%; border:1px solid black;">
				 <h3 class="header">Tests Performed</h3>
			
					<br>
					 <table width="98%" align="center" cellpadding="3" cellspacing="0" style="font-size:100%;">            				
					    <tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Test Performed At</label></td>
						 <td>
						 	#WWM_TEST_LOCATION#		     
					     </td>
					    </tr>
						<cfif WWM_TEST_LOCATION IS "Roadside">
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">FIT Test?</label></td>
						 <td>
						 	#iif(ROADSIDE_FIT_DONE IS "Y",DE('Yes'),de('No'))#
						 	<cfif ROADSIDE_FIT_DONE IS "Y">
							  <cfif Len(ROADSIDE_FIT_TIME) GT 0>
							   <br>#ROADSIDE_FIT_TIME#
							  </cfif>
							  <cfif Len(ROADSIDE_FIT_RESULT) GT 0>
							   <br>#ROADSIDE_FIT_RESULT#
							  </cfif> 	
							</cfif>		     
					     </td>
					    </tr>
						<cfif Len(ROADSIDE_BREATH_DONE) GT 0>
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Breath Test?</label></td>
						 <td>
						 	#iif(ROADSIDE_BREATH_DONE IS "Y",DE('Yes'),de('No'))#
						 	<cfif ROADSIDE_BREATH_DONE IS "Y">
							  <cfif Len(ROADSIDE_BREATH_TIME) GT 0>
							   <br>#ROADSIDE_BREATH_TIME#
							  </cfif>
							  <cfif Len(ROADSIDE_BREATH_RESULT) GT 0>
							   <br>#ROADSIDE_BREATH_RESULT# &##181;g/100 ml
							  </cfif> 	
							</cfif>			     
					     </td>
					    </tr>
						</cfif>
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Drug Swipe?</label></td>
						 <td>
						 	#iif(ROADSIDE_SALIVA_DONE IS "Y",DE('Yes'),de('No'))#
						 	<cfif ROADSIDE_SALIVA_DONE IS "Y">
							  <br>Batch: #TEST_REF#
							  <cfif Len(ROADSIDE_SALIVA_TIME) GT 0>
							   <br>#ROADSIDE_SALIVA_TIME#
							  </cfif>
							  <cfif Len(ROADSIDE_SALIVA_RESULT) GT 0>
							   <br>#ROADSIDE_SALIVA_RESULT#
							  </cfif>
							  <cfif Len(ROADSIDE_SALIVA_DRUG) GT 0>
							   <br>#ROADSIDE_SALIVA_DRUG#
							  </cfif> 	 	
							</cfif>		     
					     </td>
					    </tr>			
						</cfif>
						<cfif WWM_TEST_LOCATION IS "Station">
						<cfif Len(STATION_BREATH_DONE) GT 0>
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Breath Test?</label></td>
						 <td>
						 	#iif(STATION_BREATH_DONE IS "Y",DE('Yes'),de('No'))#
						 	<cfif STATION_BREATH_DONE IS "Y">
							  <cfif Len(STATIONE_BREATH_TIME) GT 0>
							   <br>#STATION_BREATH_TIME#
							  </cfif>
							  <cfif Len(STATION_BREATH_RESULT) GT 0>
							   <br>#STATION_BREATH_RESULT# &##181;g/100 ml
							  </cfif> 	
							</cfif>			     
					     </td>
					    </tr>
						</cfif>
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Drug Swipe?</label></td>
						 <td>
						 	#iif(STATION_SALIVA_DONE IS "Y",DE('Yes'),de('No'))#
						 	<cfif STATION_SALIVA_DONE IS "Y">
							  <br>Batch: #TEST_REF#	
							  <cfif Len(STATION_SALIVA_TIME) GT 0>
							   <br>#STATION_SALIVA_TIME#
							  </cfif>
							  <cfif Len(STATION_SALIVA_RESULT) GT 0>
							   <br>#STATION_SALIVA_RESULT#
							  </cfif>
							  <cfif Len(STATION_SALIVA_DRUG) GT 0>
							   <br>#STATION_SALIVA_DRUG#
							  </cfif> 	 	
							</cfif>		     
					     </td>
					    </tr>					
						</cfif>
						<cfif WWM_TEST_LOCATION IS "Hospital">
						<tr>
					     <td width="25%" valign="top"><label style="font-weight:bold;">Drug Swipe?</label></td>
						 <td>
						 	#iif(STATION_SALIVA_DONE IS "Y",DE('Yes'),de('No'))#
						 	<cfif STATION_SALIVA_DONE IS "Y">
							  <br>Batch: #TEST_REF#	
							  <cfif Len(STATION_SALIVA_TIME) GT 0>
							   <br>#STATION_SALIVA_TIME#
							  </cfif>
							  <cfif Len(STATION_SALIVA_RESULT) GT 0>
							   <br>#STATION_SALIVA_RESULT#
							  </cfif>
							  <cfif Len(STATION_SALIVA_DRUG) GT 0>
							   <br>#STATION_SALIVA_DRUG#
							  </cfif> 	 	
							</cfif>		     
					     </td>
					    </tr>					
						</cfif>
					 </table>  
			
			    </div>
				
				<br>
				<div style="width:98%; border:1px solid black;">
				 <h3 class="header">Person / Arrest</h3>
				 <br>
					 <table width="98%" align="center" cellpadding="3" cellspacing="0" style="font-size:100%;">
				 	<tr>
					   <td width="25%" valign="top"><label style="font-weight:bold;">Arrested?</label></td>
					   <td>
					   	 #iif(ARRESTED IS "Y",DE('Yes'),de('No'))#
					   	 <cfif ARRESTED IS "Y">
							Arrested For:
							<cfif ARRESTED_FOR_DRUGSORALC IS "Y">
							Section 4 Alcohol and/or drugs
							</cfif>
							<cfif ARRESTED_FOR_S4ALC IS "Y">
							Section 4 Alcohol
							</cfif>	
							<cfif ARRESTED_FOR_S5ALC IS "Y">
							Section 5 Alcohol
							</cfif>	
							<cfif ARRESTED_FOR_S4DRUGS IS "Y">
							Section 4 Drugs
							</cfif>	
							<cfif ARRESTED_FOR_S5DRUGS IS "Y">
							Section 5 Drugs
							</cfif>	
							<cfif ARRESTED_FOR_FAILURE IS "Y">
							Fail to provide
							</cfif>	
							<cfif Len(ARRESTED_FOR_OTHER) GT 0>
							#ARRESTED_FOR_OTHER#
							</cfif>		
							<cfif INVESTIGATION_FOR_DRUGSORALC IS "Y">
							Section 4 Alcohol and/or drugs
							</cfif>
							<cfif INVESTIGATION_FOR_S4ALC IS "Y">
							Section 4 Alcohol
							</cfif>	
							<cfif INVESTIGATION_FOR_S5ALC IS "Y">
							Section 5 Alcohol
							</cfif>	
							<cfif INVESTIGATION_FOR_S4DRUGS IS "Y">
							Section 4 Drugs
							</cfif>	
							<cfif INVESTIGATION_FOR_S5DRUGS IS "Y">
							Section 5 Drugs
							</cfif>	
							<cfif INVESTIGATION_FOR_FAILURE IS "Y">
							Fail to provide
							</cfif>	
							<cfif Len(ARRESTED_FOR_OTHER) GT 0>
							#INVESTIGATION_FOR_OTHER#
							</cfif>		
						 </cfif>
					   </td>
					</tr>
					<cfif Len(CUSTODY_REF) GT 0>
					<tr>
					   <td width="25%" valign="top"><label style="font-weight:bold;">Custody Ref</label></td>
					   <td>#CUSTODY_REF#
					   </td>
					</tr>
					</cfif>
					<cfif Len(REASON_NOT_ARRESTED) GT 0>
					<tr>
					   <td width="25%" valign="top"><label style="font-weight:bold;">Reason Not Arrested</label></td>
					   <td>#REASON_NOT_ARRESTED#
					   </td>
					</tr>
					</cfif>				
					<tr>
					   <td width="25%" valign="top"><label style="font-weight:bold;">Age</label></td>
					   <td>
					   	#AGE#
					   </td>
					</tr>
					<tr>
					   <td width="25%" valign="top"><label style="font-weight:bold;">Sex</label></td>
					   <td>
					   	#GENDER#
					   </td>
					</tr>
					<tr>
					   <td width="25%" valign="top"><label style="font-weight:bold;">Self Defined Ethnicity</label></td>
					   <td>
					   	#ETHICITY#
					   </td>
					</tr>
					<tr>
					   <td width="25%" valign="top"><label style="font-weight:bold;">Officer Defined Ethnicity</label></td>
					   <td>
					   	#WWM_OFF_ETHNICITY#
					   </td>
					</tr>
				  </table>
				</div>
			
				<br>
				<div style="width:98%; border:1px solid black;">
				 <h3 class="header">Additional</h3>
				 <br>
		
				 <cfif Len(ADDITIONAL_INFORMATION) GT 0>
				 	#ADDITIONAL_INFORMATION#
				 <cfelse>
				    None
				 </cfif>	
				 
				 <br><br>
				</div>
			    </cfoutput>
			  </body>
			  </html>
			</cfdocument>
			
			</cfloop>
					
	</cffunction>

	<cffunction name="deleteDrugDrive" description="sets logically deleted flag to Y for INCOMPLETE submissions" 
				access="remote" output="false" returntype="struct">
		<cfargument name="DD_ID" type="string" required="true" hint="DD_ID to set logically deleted for" >	

		<cfset var qDD="">
		<cfset var returnStruct=structNew()>
		
		<cfset returnStruct.success=true>

        <cfquery name="qDD" datasource="#variables.dsn#">
			UPDATE FF_OWNER.DRUG_DRIVE
			   SET LOGICALLY_DELETED=<cfqueryparam value="Y" cfsqltype="cf_sql_varchar" />
			WHERE WWM_DD_ID=<cfqueryparam value="#DD_ID#" cfsqltype="cf_sql_numeric" />			  
		</cfquery>
		
		<cfreturn returnStruct>

	</cffunction>

	<cffunction name="getUserDrugDrive" description="gets a list of users drug drive entries" access="remote" output="false" returntype="query">
		<cfargument name="userId" type="string" required="true" hint="user to get list for" >	

		<cfset var qDD="">

        <cfquery name="qDD" datasource="#variables.dsn#">
			SELECT WWM_DD_ID,
			       WWM_URN,
			       REPLACE(WWM_URN,'DRUGDRIVE/','') AS SHORT_URN,
			       REPLACE(WWM_URN,'/','_') AS FILE_URN,
			       WWM_TEST_LOCATION,
			       WWM_TEST_REASON,
			       WWM_NOMINAL_REF,
			       WWM_NOMINAL_NAME,
			       TO_CHAR(DATE_GENERATED,'YYYYMMDDHH24MMSS') AS DATE_GENERATED_TSTAMP_ORDER,
			       TO_CHAR(DATE_GENERATED,'YYYY-MM-DD')||'T'||TO_CHAR(DATE_GENERATED,'HH24:MI:SS')||'.000Z' AS DATE_GENERATED_TSTAMP,
			       TO_CHAR(DATE_INITIAL_STOP,'YYYY-MM-DD')||'T'||TO_CHAR(DATE_INITIAL_STOP,'HH24:MI:SS')||'.000Z' AS DATE_INITIAL_STOP_TSTAMP,			       
			       TIME_INITIAL_STOP,
			       ROADSIDE_FIT_DONE,
			       ROADSIDE_FIT_RESULT,			       
			       NVL(NVL(ROADSIDE_SALIVA_DONE,STATION_SALIVA_DONE),HOSPITAL_SALIVA_DONE) AS DRUG_DONE,
			       NVL(NVL(ROADSIDE_SALIVA_RESULT,STATION_SALIVA_RESULT),HOSPITAL_SALIVA_RESULT) AS DRUG_RESULT,
			       NVL(NVL(ROADSIDE_SALIVA_DRUG,STATION_SALIVA_DRUG),HOSPITAL_SALIVA_DRUG) AS DRUG_DETECTED,
			       ARRESTED,
			       CUSTODY_REF
			FROM  FF_OWNER.DRUG_DRIVE
			WHERE WWM_OFFICER_UID=<cfqueryparam value="#userId#" cfsqltype="cf_sql_varchar" />
			  AND LOGICALLY_DELETED=<cfqueryparam value="N" cfsqltype="cf_sql_varchar" />
			ORDER BY DATE_GENERATED DESC
		</cfquery>
		
		<cfreturn qDD>

	</cffunction>

	<cffunction name="getAdminDrugDrive" description="gets a list of all completed drug drive entries" access="remote" output="false" returntype="query">

		<cfset var qDD="">

        <cfquery name="qDD" datasource="#variables.dsn#">
			SELECT WWM_DD_ID,
			       WWM_URN,
			       REPLACE(WWM_URN,'DRUGDRIVE/','') AS SHORT_URN,
			       WWM_TEST_LOCATION,
			       WWM_TEST_REASON,
			       WWM_NOMINAL_REF,
			       WWM_NOMINAL_NAME,
			       WWM_OFFICER_NAME,
			       TO_CHAR(DATE_GENERATED,'YYYYMMDDHH24MMSS') AS DATE_GENERATED_TSTAMP_ORDER,
			       TO_CHAR(DATE_GENERATED,'YYYY-MM-DD')||'T'||TO_CHAR(DATE_GENERATED,'HH24:MI:SS')||'.000Z' AS DATE_GENERATED_TSTAMP,
			       TO_CHAR(DATE_INITIAL_STOP,'YYYY-MM-DD')||'T'||TO_CHAR(DATE_INITIAL_STOP,'HH24:MI:SS')||'.000Z' AS DATE_INITIAL_STOP_TSTAMP,			       
			       TIME_INITIAL_STOP,
			       ROADSIDE_FIT_DONE,
			       ROADSIDE_FIT_RESULT,			       
			       NVL(NVL(ROADSIDE_SALIVA_DONE,STATION_SALIVA_DONE),HOSPITAL_SALIVA_DONE) AS DRUG_DONE,
			       NVL(NVL(ROADSIDE_SALIVA_RESULT,STATION_SALIVA_RESULT),HOSPITAL_SALIVA_RESULT) AS DRUG_RESULT,
			       NVL(NVL(ROADSIDE_SALIVA_DRUG,STATION_SALIVA_DRUG),HOSPITAL_SALIVA_DRUG) AS DRUG_DETECTED,
			       ARRESTED,
			       CUSTODY_REF
			FROM  FF_OWNER.DRUG_DRIVE
			WHERE WWM_URN IS NOT NULL			  
			ORDER BY DATE_GENERATED DESC
		</cfquery>
		
		<cfreturn qDD>

	</cffunction>

	<cffunction name="createDDPDF" description="Creates a drug drive PDF form, returns the path and filename to the created form" access="remote" output="false" returntype="struct">
		<cfargument name="DD_ID" type="string" required="true" hint="DD_ID of test to create the PDF for" >		

		<cfset var pdfCreated=structNew()>
		<cfset var qDbToPdfLookup=getDbtoPdfLookup(lookupFile=variables.dbToPdfLookupFile)>
		<cfset var ddRow=getDrugDrive(DD_ID=arguments.DD_ID)>
		<cfset var hoFileName=Replace(ddRow.WWM_URN,"/","_","ALL")&"_ho.pdf">
		<cfset var wwmFileName=Replace(ddRow.WWM_URN,"/","_","ALL")&"_wwm.pdf">
		<cfset var pdfPath=variables.pdfLocation & DateFormat(ddRow.WWM_DATE_CREATED,"YYYY") & "\" & DateFormat(ddRow.WWM_DATE_CREATED,'MM')&"\">
		<cfset var thisVal=''>
		
		<cfif not DirectoryExists(pdfPath)>
			<cfdirectory action="create" directory="#pdfPath#" >
		</cfif>
		
		<cfpdfform action="populate" 
				   source="#variables.templateFile#"
				   destination="#pdfPath##hoFileName#"
				   overwrite="yes" overwritedata="yes">
			
			 <cfoutput query="ddRow">
			 <cflog file="ddService" type="information" text="================================================" >	
			 <cflog file="ddService" type="information" text="processing #DD_ID# #WWM_URN#" >	
			 <cfloop query="qDbToPdfLookup">
			 	<cflog file="ddService" type="information" text="processing #DB_NAME#, #PDF_NAME#, #FIELD_TYPE# current row" >
			 	<cflog file="ddService" type="information" text="current row  data is #ddRow[DB_NAME][1]#" >
			 	<cfset thisVal=''>
			 	<cfif FIELD_TYPE IS "On">
			 		<cfif ddRow[DB_NAME][1] IS "Y">
			 			<cfset thisVal='On'>
			 		</cfif>
			 	<cfelseif FIELD_TYPE IS "Date">
			 		<cfset thisVal=DateFormat(ddRow[DB_NAME][1],"DD/MM/YYYY")>
			 	<cfelse>
			 	    <cfset thisVal=ddRow[DB_NAME][1]>
			 	</cfif>
			 	
			 	<cfif DB_NAME IS "ADDITIONAL_INFORMATION">
			 		<cfset thisVal="URN: "&ddRow['WWM_URN'][1]&chr(10)&thisVal>
			 	</cfif>
			 	
			 	<cfpdfformparam name="#PDF_NAME#" value="#thisVal#">
			 	<cflog file="ddService" type="information" text="processed #DB_NAME#, #PDF_NAME#, #FIELD_TYPE# == #thisVal#" >
			 </cfloop>	   			
			 </cfoutput>	   
			
		</cfpdfform>
		
		<!--- flatten the form so it now cannot be altered --->
		<cfpdf action="write" destination="#pdfPath##wwmFileName#" source="#pdfPath##hoFileName#" flatten="true" overwrite="true">	
		
		<cfset pdfCreated.pdfPath=pdfPath>
		<cfset pdfCreated.pdfFile=wwmFileName>
		
		<cfreturn pdfCreated>
		
	</cffunction>
	
	<cffunction name="getDbtoPdfLookup" descriptio="reads in a lookup file to convert db fields to the pdf fields" returntype="query">		
		<cfargument name="lookupFile" required="true" type="string" hint="full path to lookup file">
		
		<cfset var qLookup=queryNew('PDF_NAME,DB_NAME,FIELD_TYPE','varchar,varchar,varchar')>
		<cfset var sFileContents=''>
		<cfset var sFileLine=''>
		<cfset var iDataLine=1>
		
		<cffile action="read" file="#arguments.lookupFile#" variable="sFileContents" />
		
		
		<cfloop list="#sFileContents#" index="sFileLine" delimiters="#chr(10)#">
			
			<!--- 1st line of lookup file is column headers --->
			<cfif iDataLine GT 1>
			
				<cfset sFileLine=trim(stripCr(sFileLine))>
			
				<cfset queryAddrow(qLookup)>
				<cfset querySetCell(qLookup,'PDF_NAME',listGetAt(sFileLine,1,"|"))>
				<cfset querySetCell(qLookup,'DB_NAME',listGetAt(sFileLine,2,"|"))>
				<cfset querySetCell(qLookup,'FIELD_TYPE',listGetAt(sFileLine,3,"|"))>
		
			</cfif>
		    <cfset iDataLine++>
		</cfloop>
		
		<cfreturn qLookup>
				
	</cffunction>

	<cffunction name="getIsAdminUser" description="returns boolean if user id is an admin" access="remote" output="false" returntype="boolean">
		<cfargument name="userId" type="string" required="true" hint="user to get list for" >	

		<cfset var qDD="">
        <cfset var isAdmin=false>
		
        <cfquery name="qDD" datasource="#variables.dsn#">
			SELECT *
			FROM   DRUG_DRIVE_ADMIN
			WHERE  ADMIN_USER_ID=<cfqueryparam value="#userId#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfif qDD.recordCount GT 0>
			<cfset isAdmin=true>
		</cfif>
		
		<cfreturn isAdmin>

	</cffunction>

    <cffunction name="QueryToStruct" access="public" returntype="any" output="false"
    	hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">

	    <!--- Define arguments. --->
	    <cfargument name="Query" type="query" required="true" />
	    <cfargument name="Row" type="numeric" required="false" default="0" />
	
	    <cfscript>
	        // Define the local scope.
	        var LOCAL = StructNew();
	        // Determine the indexes that we will need to loop over.
	        // To do so, check to see if we are working with a given row,
	        // or the whole record set.
	        if (ARGUMENTS.Row){
	            // We are only looping over one row.
	            LOCAL.FromIndex = ARGUMENTS.Row;
	            LOCAL.ToIndex = ARGUMENTS.Row;
	        } else {
	            // We are looping over the entire query.
	            LOCAL.FromIndex = 1;
	            LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;
	        }
	        // Get the list of columns as an array and the column count.
	        LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
	        LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );
	        // Create an array to keep all the objects.
	        LOCAL.DataArray = ArrayNew( 1 );
	        // Loop over the rows to create a structure for each row.
	        for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
	            // Create a new structure for this row.
	            ArrayAppend( LOCAL.DataArray, StructNew() );
	            // Get the index of the current data array object.
	            LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );
	            // Loop over the columns to set the structure values.
	            for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
	                // Get the column value.
	                LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
	                // Set column value into the structure.
	                LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
	            }
	        }
	        // At this point, we have an array of structure objects that
	        // represent the rows in the query over the indexes that we
	        // wanted to convert. If we did not want to convert a specific
	        // record, return the array. If we wanted to convert a single
	        // row, then return the just that STRUCTURE, not the array.
	        if (ARGUMENTS.Row){
	            // Return the first array item.
	            return( LOCAL.DataArray[ 1 ] );
	        } else {
	            // Return the entire array.
	            return( LOCAL.DataArray );
	        }
	    </cfscript>
	</cffunction>


</cfcomponent>
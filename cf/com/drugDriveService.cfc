<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="drugDriveService">
		<cfargument name="dsn" type="string" hint="datasource of drug drive database" required="true" />
		<cfargument name="templateFile" type="string" hint="dft base pdf file to send work off" required="true" />
		<cfargument name="dbToPdfLookupFile" type="string" hint="lookup file to map database to pdf" required="true" />
		<cfargument name="pdfLocation" type="string" hint="location of where pdfs are written too" required="true" />
		<cfargument name="reportTemp" type="string" hint="location of where reports written too" required="true" />				
				
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.templateFile = arguments.templateFile />
		<cfset variables.dbToPdfLookupFile = arguments.dbToPdfLookupFile />
		<cfset variables.pdfLocation = arguments.pdfLocation />		
		<cfset variables.reportTemp = arguments.reportTemp />		
		
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
		<cfargument name="DD_ID" type="string" required="true" hint="DD_ID of test to create the PDF for" >	

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
		
		</cflock>
		
     <cfreturn returnStruct>
		
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

	<cffunction name="createXl" description="" access="remote" output="false" returntype="string">
		<cfargument name="fromDate" type="string" required="true" hint="date to start report">
		<cfargument name="toDate" type="string" required="true" hint="date to finish report">	

		<cfset var arrayAreas="">
        <cfset var fileCreated="">
        <cfset var reportXls="">
        <cfset var i=0>
        <cfset var qDataTotal=''>
		<cfset var qPositive=''>
		<cfset var qArrest=''>
		<cfset var qCannabis=''>
		<cfset var qCocaine=''>
		<cfset var qFIT=''>
		<cfset var qFITOk=''>
		<cfset var qFITPoor=''>
		
        <cfset arrayAreas=arrayNew(1)>
		<cfset arrayAreas[1]=structNew()>
		<cfset arrayAreas[1].name='Alliance'>
		<cfset arrayAreas[1].rowNo=2>
		<cfset arrayAreas[1].areaSQL=''>
		<cfset arrayAreas[2]=structNew()>
		<cfset arrayAreas[2].name='Warwickshire'>
		<cfset arrayAreas[2].rowNo=4>
		<cfset arrayAreas[2].areaSQL="WWM_URN LIKE 'DRUGDRIVE/23/%'">
		<cfset arrayAreas[3]=structNew()>
		<cfset arrayAreas[3].name='North Warwickshire'>
		<cfset arrayAreas[3].rowNo=5>
		<cfset arrayAreas[3].areaSQL="WWM_URN LIKE 'DRUGDRIVE/23/N%'">
		<cfset arrayAreas[4]=structNew()>
		<cfset arrayAreas[4].name='South Warwickshire'>
		<cfset arrayAreas[4].rowNo=6>
		<cfset arrayAreas[4].areaSQL="WWM_URN LIKE 'DRUGDRIVE/23/S%'">
		<cfset arrayAreas[5]=structNew()>
		<cfset arrayAreas[5].name='Motorway'>
		<cfset arrayAreas[5].rowNo=7>
		<cfset arrayAreas[5].areaSQL="WWM_URN LIKE 'DRUGDRIVE/23/MW%'">
		<cfset arrayAreas[6]=structNew()>
		<cfset arrayAreas[6].name='West Mercia'>
		<cfset arrayAreas[6].rowNo=9>
		<cfset arrayAreas[6].areaSQL="WWM_URN LIKE 'DRUGDRIVE/22%'">
		<cfset arrayAreas[7]=structNew()>
		<cfset arrayAreas[7].name='South Worcestershire'>
		<cfset arrayAreas[7].rowNo=10>
		<cfset arrayAreas[7].areaSQL="WWM_URN LIKE 'DRUGDRIVE/22/C%'">
		<cfset arrayAreas[8]=structNew()>
		<cfset arrayAreas[8].name='North Worcestershire'>
		<cfset arrayAreas[8].rowNo=11>
		<cfset arrayAreas[8].areaSQL="WWM_URN LIKE 'DRUGDRIVE/22/D%'">
		<cfset arrayAreas[9]=structNew()>
		<cfset arrayAreas[9].name='Herefordshire'>
		<cfset arrayAreas[9].rowNo=12>
		<cfset arrayAreas[9].areaSQL="WWM_URN LIKE 'DRUGDRIVE/22/E%'">
		<cfset arrayAreas[10]=structNew()>
		<cfset arrayAreas[10].name='Shropshire'>
		<cfset arrayAreas[10].rowNo=13>
		<cfset arrayAreas[10].areaSQL="WWM_URN LIKE 'DRUGDRIVE/22/F%'">
		<cfset arrayAreas[11]=structNew()>
		<cfset arrayAreas[11].name='Telford & Wrekin'>
		<cfset arrayAreas[11].rowNo=14>
		<cfset arrayAreas[11].areaSQL="WWM_URN LIKE 'DRUGDRIVE/22/G%'">	
		
		<cfset reportXls=SpreadsheetNew('DrugDrive_Report')>

		<cfset SpreadSheetSetCellValue(reportXls,'Drug Wipe Tests',1,2)>
		<cfset SpreadSheetSetCellValue(reportXls,'Postive',1,3)>
		<cfset SpreadSheetSetCellValue(reportXls,'Negative',1,4)>
		<cfset SpreadSheetSetCellValue(reportXls,'Arrests',1,5)>
		<cfset SpreadSheetSetCellValue(reportXls,'Cannabis',1,6)>
		<cfset SpreadSheetSetCellValue(reportXls,'Cocaine',1,7)>
		<cfset SpreadSheetSetCellValue(reportXls,'FIT',1,9)>
		<cfset SpreadSheetSetCellValue(reportXls,'Performed OK',1,10)>
		<cfset SpreadSheetSetCellValue(reportXls,'Performed Poorly',1,11)>
		
		<cfloop from="1" to="#ArrayLen(arrayAreas)#" index="i">
			
			<cfset SpreadSheetSetCellValue(reportXls,arrayAreas[i].name, arrayAreas[i].rowNo,1)>

			<cfquery name="qDataTotal" datasource="#application.dsn#">
				SELECT COUNT(*) AS DTOTAL
				FROM   FF_OWNER.DRUG_DRIVE dd
				WHERE  WWM_URN IS NOT NULL
				  AND  (   ROADSIDE_SALIVA_DONE = 'Y'
				               OR STATION_SALIVA_DONE = 'Y'
				               OR HOSPITAL_SALIVA_DONE = 'Y' 	              
				        )
				  AND  DATE_INITIAL_STOP BETWEEN TO_DATE('#fromDate# 00:00:00','DD-MON-YYYY HH24:MI:SS')
				                             AND TO_DATE('#toDate# 23:59:59','DD-MON-YYYY HH24:MI:SS')
				  <cfif Len(arrayAreas[i].areaSql) GT 0>
				  <cfset sqlData=arrayAreas[i].areaSql>
				  AND #preserveSingleQuotes(sqlData)#	
				  </cfif>
			</cfquery>	
			
			<cfquery name="qPositive" datasource="#application.dsn#">
			    SELECT COUNT(*) AS POSITIVE
			    FROM   FF_OWNER.DRUG_DRIVE dd
			    WHERE  WWM_URN IS NOT NULL
			      AND  (   ROADSIDE_SALIVA_RESULT = 'Positive'
			                   OR STATION_SALIVA_RESULT = 'Positive'
			                   OR HOSPITAL_SALIVA_RESULT = 'Positive'                  
			            )
				  AND  DATE_INITIAL_STOP BETWEEN TO_DATE('#fromDate# 00:00:00','DD-MON-YYYY HH24:MI:SS')
				                             AND TO_DATE('#toDate# 23:59:59','DD-MON-YYYY HH24:MI:SS')
				  <cfif Len(arrayAreas[i].areaSql) GT 0>
				  <cfset sqlData=arrayAreas[i].areaSql>
				  AND #preserveSingleQuotes(sqlData)#	
				  </cfif>	                             
			</cfquery>	
			
			<cfquery name="qArrest" datasource="#application.dsn#">
			    SELECT COUNT(*) AS ARREST
			    FROM   FF_OWNER.DRUG_DRIVE dd
			    WHERE  WWM_URN IS NOT NULL
			      AND  ARRESTED = 'Y'
				  AND  DATE_INITIAL_STOP BETWEEN TO_DATE('#fromDate# 00:00:00','DD-MON-YYYY HH24:MI:SS')
				                             AND TO_DATE('#toDate# 23:59:59','DD-MON-YYYY HH24:MI:SS')
				  <cfif Len(arrayAreas[i].areaSql) GT 0>
				  <cfset sqlData=arrayAreas[i].areaSql>
				  AND #preserveSingleQuotes(sqlData)#	
				  </cfif>	                             
			</cfquery>	
			
			<cfquery name="qCannabis" datasource="#application.dsn#">
			    SELECT COUNT(*) AS CANNABIS
			    FROM   FF_OWNER.DRUG_DRIVE dd
			    WHERE  WWM_URN IS NOT NULL
			      AND  (
			               ROADSIDE_SALIVA_DRUG LIKE '%Cannabis%'
			            OR STATION_SALIVA_DRUG LIKE '%Cannabis%'
			            OR HOSPITAL_SALIVA_DRUG LIKE '%Cannabis%'
			           )
				  AND  DATE_INITIAL_STOP BETWEEN TO_DATE('#fromDate# 00:00:00','DD-MON-YYYY HH24:MI:SS')
				                             AND TO_DATE('#toDate# 23:59:59','DD-MON-YYYY HH24:MI:SS')
				  <cfif Len(arrayAreas[i].areaSql) GT 0>
				  <cfset sqlData=arrayAreas[i].areaSql>
				  AND #preserveSingleQuotes(sqlData)#	
				  </cfif>	                             
			</cfquery>	
			
			<cfquery name="qCocaine" datasource="#application.dsn#">
			    SELECT COUNT(*) AS COCAINE
			    FROM   FF_OWNER.DRUG_DRIVE dd
			    WHERE  WWM_URN IS NOT NULL
			      AND  (
			               ROADSIDE_SALIVA_DRUG LIKE '%Cocaine%'
			            OR STATION_SALIVA_DRUG LIKE '%Cocaine%'
			            OR HOSPITAL_SALIVA_DRUG LIKE '%Cocaine%'
			           )
				  AND  DATE_INITIAL_STOP BETWEEN TO_DATE('#fromDate# 00:00:00','DD-MON-YYYY HH24:MI:SS')
				                             AND TO_DATE('#toDate# 23:59:59','DD-MON-YYYY HH24:MI:SS')
				  <cfif Len(arrayAreas[i].areaSql) GT 0>
				  <cfset sqlData=arrayAreas[i].areaSql>
				  AND #preserveSingleQuotes(sqlData)#	
				  </cfif>	                             
			</cfquery>	
			
			<cfquery name="qFIT" datasource="#application.dsn#">
			    SELECT COUNT(*) AS FIT
			    FROM   FF_OWNER.DRUG_DRIVE dd
			    WHERE  WWM_URN IS NOT NULL
			      AND  ROADSIDE_FIT_DONE = 'Y'            
				  AND  DATE_INITIAL_STOP BETWEEN TO_DATE('#fromDate# 00:00:00','DD-MON-YYYY HH24:MI:SS')
				                             AND TO_DATE('#toDate# 23:59:59','DD-MON-YYYY HH24:MI:SS')
				  <cfif Len(arrayAreas[i].areaSql) GT 0>
				  <cfset sqlData=arrayAreas[i].areaSql>
				  AND #preserveSingleQuotes(sqlData)#	
				  </cfif>	                             
			</cfquery>	
			
			<cfquery name="qFITOk" datasource="#application.dsn#">
			    SELECT COUNT(*) AS FIT
			    FROM   FF_OWNER.DRUG_DRIVE dd
			    WHERE  WWM_URN IS NOT NULL
			      AND  ROADSIDE_FIT_RESULT = 'OK'            
				  AND  DATE_INITIAL_STOP BETWEEN TO_DATE('#fromDate# 00:00:00','DD-MON-YYYY HH24:MI:SS')
				                             AND TO_DATE('#toDate# 23:59:59','DD-MON-YYYY HH24:MI:SS')
				  <cfif Len(arrayAreas[i].areaSql) GT 0>
				  <cfset sqlData=arrayAreas[i].areaSql>
				  AND #preserveSingleQuotes(sqlData)#	
				  </cfif>	                             
			</cfquery>	
			
			<cfquery name="qFITPoor" datasource="#application.dsn#">
			    SELECT COUNT(*) AS FIT
			    FROM   FF_OWNER.DRUG_DRIVE dd
			    WHERE  WWM_URN IS NOT NULL
			      AND  ROADSIDE_FIT_RESULT = 'POOR'            
				  AND  DATE_INITIAL_STOP BETWEEN TO_DATE('#fromDate# 00:00:00','DD-MON-YYYY HH24:MI:SS')
				                             AND TO_DATE('#toDate# 23:59:59','DD-MON-YYYY HH24:MI:SS')
				  <cfif Len(arrayAreas[i].areaSql) GT 0>
				  <cfset sqlData=arrayAreas[i].areaSql>
				  AND #preserveSingleQuotes(sqlData)#	
				  </cfif>	                             
			</cfquery>	
			
			<cfset SpreadSheetSetCellValue(reportXls,qDataTotal.DTOTAL,arrayAreas[i].rowNo,2)>
			<cfset SpreadSheetSetCellValue(reportXls,qPositive.POSITIVE,arrayAreas[i].rowNo,3)>
			<cfset SpreadSheetSetCellValue(reportXls,qDataTotal.DTOTAL-qPositive.POSITIVE,arrayAreas[i].rowNo,4)>
			<cfset SpreadSheetSetCellValue(reportXls,qArrest.ARREST,arrayAreas[i].rowNo,5)>
			<cfset SpreadSheetSetCellValue(reportXls,qCannabis.CANNABIS,arrayAreas[i].rowNo,6)>
			<cfset SpreadSheetSetCellValue(reportXls,qCocaine.COCAINE,arrayAreas[i].rowNo,7)>
			<cfset SpreadSheetSetCellValue(reportXls,qFIT.FIT,arrayAreas[i].rowNo,9)>
			<cfset SpreadSheetSetCellValue(reportXls,qFITOk.FIT,arrayAreas[i].rowNo,10)>
			<cfset SpreadSheetSetCellValue(reportXls,qFITPoor.FIT,arrayAreas[i].rowNo,11)>
			
		</cfloop>
		
		<cfset fileCreated=variables.reportTemp&dateFormat(now(),'YYYYMMDD')&TimeFormat(now(),'HHmmss')&".xls">
		
		<cfspreadsheet action="write" filename="#fileCreated#" sheetname="Drug Drive Statistics" name="reportXls" overwrite="true">	
		
		<cfreturn fileCreated>

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
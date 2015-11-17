<cfcomponent output="false">

    <cffunction name="initVars" description="initialises db sources etc.." access="remote" returntype="struct" >
    	
    	<cfset var serviceVars=structNew()>
    	
    	<cfif SERVER_NAME IS "127.0.0.1" OR SERVER_NAME IS "localhost">
    		<cfset serviceVars.DD_DB="DrugDrive">
    		<cfset serviceVars.templateFile="C:\ColdFusion10\cfusion\wwwroot\drugDrive\cf\pdfTemplates\hoDrugDriveFormV1.pdf">
    		<cfset serviceVars.dbToPdfLookupFile="C:\ColdFusion10\cfusion\wwwroot\drugDrive\cf\com\dbToPdfLookup.txt">
    		<cfset serviceVars.pdfLocation="C:\ColdFusion10\cfusion\wwwroot\drugDrive\pdfOutput\">
    	<cfelseif SERVER_NAME IS "development.intranet.wmcpolice">
    		<cfset serviceVars.DD_DB="DrugDriveNew">
    		<cfset serviceVars.templateFile="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\dd\cf\pdfTemplates\hoDrugDriveFormV1.pdf">
    		<cfset serviceVars.dbToPdfLookupFile="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\dd\cf\com\dbToPdfLookup.txt">
    		<cfset serviceVars.pdfLocation="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\pdfOutput\">    	
    	<cfelseif SERVER_NAME IS "websvr.intranet.wmcpolice">	
    		
    	</cfif>
    	
    	<cfreturn serviceVars>
    	
    </cffunction>

	<cffunction name="getDrugDrive" description="Get Drug Drive Test From DB" access="remote" output="false" returntype="struct" returnformat="JSON">
       <cfargument name="DD_ID" required="true" type="numeric" hint="DD_ID to get from DB">
       
       <cfset var qDD="">
       <cfset var fnVars=initVars()>
       
       <cfquery name="qDD" datasource="#fnVars.DD_DB#">
       	SELECT *
       	FROM   FF_OWNER.DRUG_DRIVE
       	WHERE  WWM_DD_ID=<cfqueryparam value="#arguments.DD_ID#" cfsqltype="cf_sql_numeric" />
       </cfquery>
       
       <cfreturn QueryToStruct(qDD,1)>
       
	</cffunction>

	<cffunction name="createDrugDrive" description="Creates / Updates a Drug Drive Form" access="remote" output="false" returntype="struct" returnformat="JSON" >
              
       <cfset var qDD="">
       <cfset var qNextSeq="">
       <cfset var fnVars=initVars()>
       <cfset var incomingData=toString( getHttpRequestData().content )>
       <cfset var formData=structNew()>
       <cfset var returnStruct=structNew()>
       <cfset var qDbToPdfLookup=getDbtoPdfLookup(lookupFile=fnVars.dbToPdfLookupFile)>
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
       	  <cfquery name="qNextSeq" datasource="#fnVars.DD_DB#">
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
       	  	)
       	  </cfsavecontent>
       	  </cfoutput>
       	  
       	  <cflog file="ddService" type="information" text="#insertQuery#" >
       	  
       	  <!--- insert the record --->
       	  <cfquery name="qDD" datasource="#fnVars.DD_DB#">
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
	       	  		  '#formData[DB_NAME]#'
					 </cfif>
	       	  		 <cfset iCol++>
				 </cfif>
       	  		</cfloop>       
	       	  	WHERE WWM_DD_ID = #formData['WWM_DD_ID']#	       	  			       	  	
	       	  </cfsavecontent>
	       	  </cfoutput>
          <cflog file="ddService" type="information" text="#updateQuery#" >
          <!--- update the record --->
       	  <cfquery name="qDD" datasource="#fnVars.DD_DB#">
       	  	#PreserveSingleQuotes(updateQuery)#
       	  </cfquery>
       
       </cfif>
       
       <cfset returnStruct.DD_ID=formData.WWM_DD_ID>
       
       <cfreturn returnStruct>
       
	</cffunction>

	<cffunction name="createDDPDF" description="Creates a drug drive PDF form, returns the path and filename to the created form" access="remote" output="false" returntype="struct">
		<cfargument name="DD_ID" type="string" required="true" hint="DD_ID of test to create the PDF for" >		
		
		<cfset var fnVars=initVars()>
		<cfset var pdfCreated=structNew()>
		<cfset var qDbToPdfLookup=getDbtoPdfLookup(lookupFile=fnVars.dbToPdfLookupFile)>
		<cfset var ddRow=getDrugDrive(DD_ID=arguments.DD_ID)>
		<cfset var hoFileName=Replace(ddRow.WWM_URN,"/","_","ALL")&"_ho.pdf">
		<cfset var wwmFileName=Replace(ddRow.WWM_URN,"/","_","ALL")&"_wwm.pdf">
		<cfset var pdfPath=fnVars.pdfLocation & DateFormat(ddRow.WWM_DATE_CREATED,"YYYY") & "\" & DateFormat(ddRow.WWM_DATE_CREATED,'MM')&"\">
		<cfset var thisVal=''>
		
		<cfif not DirectoryExists(pdfPath)>
			<cfdirectory action="create" directory="#pdfPath#" >
		</cfif>
		
		<cfpdfform action="populate" 
				   source="#fnVars.templateFile#"
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
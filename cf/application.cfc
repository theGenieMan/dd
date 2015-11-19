<cfcomponent>
<cfset This.name = "DrugDriveServices">
<cfset This.sessionManagement=true>
<cfset This.sessiontimeout="#createtimespan(0,0,30,0)#">
<cfset This.applicationtimeout="#createtimespan(0,0,0,0)#">

<cfset locale=SetLocale("English (UK)")>

<cffunction name="onApplicationStart">
   <cfif SERVER_NAME IS "websvr.intranet.wmcpolice" OR SERVER_NAME IS "cfsched.intranet.wmcpolice"
   	  OR SERVER_NAME IS "web474.intranet.wmcpolice" OR SERVER_NAME IS "web485.intranet.wmcpolice"
	  OR SERVER_NAME IS "web486.intranet.wmcpolice">
     <cfset Application.ENV="LIVE">
   <cfelseif SERVER_NAME IS "development.intranet.wmcpolice" OR  SERVER_NAME IS "webtest.intranet.wmcpolice">
      <cfset Application.ENV="DEV">
   <cfelse>
   	  <cfset Application.ENV="Local">
   </cfif>
   
   <cfset application.version="1.0a">
   <cfset application.serviceStarted=DateFormat(now(),"DDD DD/MM/YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>

   <cfif application.ENV IS "LIVE">
	   <cfset application.dsn="DrugDriveNew">
	   <cfset application.Warehouse_DB="wmercia">
       <cfset application.templateFile="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\dd\cf\pdfTemplates\hoDrugDriveFormV1.pdf">
       <cfset application.dbToPdfLookupFile="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\dd\cf\com\dbToPdfLookup.txt">
       <cfset application.pdfLocation="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\pdfOutput\">
	   <cfset application.WAREHOUSE_DB="wmercia">
	   <cfset application.WAREHOUSE_DB_PREFIX="BROWSER_OWNER.">
	   <cfset application.LOCATION_DB="SS_CRIMES">
	   <cfset application.LOCATION_DB_PREFIX="CRIME.">    
	   <cfset application.STORM_DB="STORM_ARC">             
   <cfelseif application.ENV IS "DEV">
	   <cfset application.dsn="DrugDriveNew">
	   <cfset application.Warehouse_DB="wmercia">
       <cfset application.templateFile="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\dd\cf\pdfTemplates\hoDrugDriveFormV1.pdf">
       <cfset application.dbToPdfLookupFile="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\dd\cf\com\dbToPdfLookup.txt">
       <cfset application.pdfLocation="\\svr20284\d$\inetpub\wwwroot\applications\force_forms\drugDriveNew\pdfOutput\">
	   <cfset application.WAREHOUSE_DB="wmercia">
	   <cfset application.WAREHOUSE_DB_PREFIX="BROWSER_OWNER.">
	   <cfset application.LOCATION_DB="SS_CRIMES">
	   <cfset application.LOCATION_DB_PREFIX="CRIME.">    
	   <cfset application.STORM_DB="STORM_ARC">     
   <cfelseif application.ENV IS "Local">
   	   <cfset application.dsn="DrugDrive">
	   <cfset application.Warehouse_DB="wmercia">    
       <cfset application.templateFile="C:\ColdFusion10\cfusion\wwwroot\drugDrive\cf\pdfTemplates\hoDrugDriveFormV1.pdf">
       <cfset application.dbToPdfLookupFile="C:\ColdFusion10\cfusion\wwwroot\drugDrive\cf\com\dbToPdfLookup.txt">
       <cfset application.pdfLocation="C:\ColdFusion10\cfusion\wwwroot\drugDrive\pdfOutput\">      
   	   <cfset application.WAREHOUSE_DB="wmercia">
	   <cfset application.WAREHOUSE_DB_PREFIX="">
	   <cfset application.LOCATION_DB="wmercia">
	   <cfset application.LOCATION_DB_PREFIX="">    
	   <cfset application.STORM_DB="wmercia">    	   
   </cfif>

             
   
  
   <cfset Application.drugDriveService=CreateObject('component','com.drugDriveService').init(dsn=application.dsn,
                                                                                             templateFile=application.templateFile,
																							 dbToPdfLookupFile=application.dbToPdfLookupFile,
                                                                                             pdfLocation=application.pdfLocation)>
																							        
   <cfset Application.officerLocationService=CreateObject('component','com.officerLocationService').init(WAREHOUSE_DB = application.WAREHOUSE_DB,
																										WAREHOUSE_DB_PREFIX = application.WAREHOUSE_DB_PREFIX,
																										LOCATION_DB = application.LOCATION_DB,
																										LOCATION_DB_PREFIX = application.LOCATION_DB_PREFIX,
																										STORM_DB = application.STORM_DB)>      
   
   
   <cfset Application.custodyService=CreateObject('component','com.custodyService').init(WAREHOUSE_DB = application.WAREHOUSE_DB)>                                                                                                  
																				  
   <cfset Application.hrService=CreateObject('component','applications.cfc.hr_alliance.hrService').init(application.WAREHOUSE_DB)>
            
</cffunction>

<!---
<cffunction name="onApplicationEnd">
</cffunction>


<cffunction name="onRequestStart">

</cffunction>
--->
<cffunction name="onRequest">
    <cfargument name = "targetPage" type="String" required="true">
		
	<cfif isDefined('resetAll')>				
		<cfset onApplicationStart()>
		<cfset onSessionStart()>
	</cfif>
	
	<cfif isDefined('resetApp')>						
		<cfset onApplicationStart()>
	</cfif>
	
	<cfif isDefined('resetSession')>						
		<cfset onSessionStart()>
	</cfif>	
	
     <cfinclude template="#Arguments.targetPage#">
</cffunction>

<!--->
<cffunction name="onRequestEnd">

</cffunction>
--->
<cffunction name="onSessionStart">

</cffunction>

<cffunction name="onSessionEnd">
</cffunction>

</cfcomponent>

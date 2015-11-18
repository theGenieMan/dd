<cfcomponent>

	<cffunction name="getDrugDrive" 
		        description="Get Drug Drive Test From DB" 
				access="remote" 
				output="false" 
				returntype="struct" 
				returnformat="JSON">
       <cfargument name="DD_ID" required="true" type="numeric" hint="DD_ID to get from DB">
	   
	   <cfset var drugDrive=application.drugDriveService.getDrugDriveJSON(DD_ID=DD_ID)>
	      
	   <cfreturn drugDrive>   
	      
	</cffunction>
	
	<cffunction name="createDrugDrive" 
		        description="Create / Update Drug Drive Test From POST Data" 
				access="remote" 
				output="false" 
				returntype="struct" 
				returnformat="JSON">
       
       <cfset var incomingData=toString( getHttpRequestData().content )>
	   
	   <cfset var drugDrive=application.drugDriveService.createDrugDrive(incomingData)>
	      
	   <cfreturn drugDrive>   
	      
	</cffunction>	

    <cffunction name="getOfficerLocation"
                access="remote"
                returntype="struct" 
                returnformat="JSON">
                
         <cfargument name="officerCollar" type="string" required="true" hint="collar number of officer" />
         <cfargument name="officerForce" type="string" required="true" hint="force of officer" />
         <cfargument name="dateToFind" type="date" required="true" hint="date to find location for" />
         <cfargument name="timeToFind" type="date" required="true" hint="time to find location for" />

       <cfset var officerLocation=application.officerLocationService.getLocation(officerCollar=officerCollar,
	                                                                             officerForce=officerForce,
																				 dateToFind=dateToFind,
																				 timeToFind=timeToFind)>
																				  
	   <cfreturn officerLocation>

	</cffunction>

</cfcomponent>
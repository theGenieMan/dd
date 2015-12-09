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
	
	<cffunction name="finaliseDrugDrive" description="Finalises the drug drive PDF form, returns the URN created" 
				access="remote" output="false" returntype="struct" returnformat="JSON" >
	   <cfargument name="DD_ID" type="string" required="true" hint="DD_ID of test to create the PDF for" >	
	
	   <cfset var drugDrive=application.drugDriveService.finaliseDrugDrive(DD_ID)>
	 
	   <cfreturn drugDrive>
	   
	</cffunction>

	<cffunction name="deleteDrugDrive" description="issues a logical deletion for a DD_ID" 
				access="remote" output="false" returntype="struct" returnformat="JSON" >
	   <cfargument name="DD_ID" type="string" required="true" hint="DD_ID to delete" >	
	
	   <cfset var drugDrive=application.drugDriveService.deleteDrugDrive(DD_ID)>
	 
	   <cfreturn drugDrive>
	   
	</cffunction>

	<cffunction name="getUserDrugDrive" description="gets an array list of submissions for a user" 
				access="remote" output="false" returntype="array" returnformat="JSON" >
	   <cfargument name="userId" type="string" required="true" hint="userId to get list for" >	
	
	   <cfset var drugDrive=application.drugDriveService.getUserDrugDrive(userId)>
	 
	   <cfreturn queryToArray(drugDrive)>
	   
	</cffunction>

	<cffunction name="getAdminDrugDrive" description="gets an array list of all completed submission for the administrator" 
				access="remote" output="false" returntype="array" returnformat="JSON" >	   
	
	   <cfset var drugDrive=application.drugDriveService.getAdminDrugDrive()>
	 
	   <cfreturn queryToArray(drugDrive)>
	   
	</cffunction>

	<cffunction name="getAdminUserList" description="gets an array list of all administrators" 
				access="remote" output="false" returntype="array" returnformat="JSON" >	   
	
	   <cfset var drugDrive=application.drugDriveService.getAdminUserList()>
	 
	   <cfreturn queryToArray(drugDrive)>
	   
	</cffunction>
	
	<cffunction name="addAdminUser" 
		        description="Adds a new admin user" 
				access="remote" 
				output="false" 
				returntype="boolean" 
				returnformat="JSON">
       
       <cfset var incomingData=toString( getHttpRequestData().content )>
	   
	   <cfset var drugDrive=application.drugDriveService.addAdminUser(incomingData)>
	      
	   <cfreturn drugDrive>   
	      
	</cffunction>		
	
	<cffunction name="deleteAdminUser" 
		        description="Deletes an admin user" 
				access="remote" 
				output="false" 
				returntype="boolean" 
				returnformat="JSON">
       <cfargument name="userId" type="string" hint="userId to remove" required="true">
       
	   <cfset var drugDrive=application.drugDriveService.deleteAdminUser(userId)>
	      
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

    <cffunction name="getCustodies"
                access="remote"
                returntype="array"
				returnformat="JSON">
				
		<cfset var custodies=application.custodyService.getCustodies()>		
				
		<cfreturn custodies>
				
	</cffunction>				

    <cffunction name="QueryToArray" access="public" returntype="array" output="false"
		hint="This turns a query into an array of structures.">
	
		<!--- Define arguments. --->
		<cfargument name="Data" type="query" required="yes" />
	
		<cfscript>
	
			// Define the local scope.
			var LOCAL = StructNew();
	
			// Get the column names as an array.
			LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );
	
			// Create an array that will hold the query equivalent.
			LOCAL.QueryArray = ArrayNew( 1 );
	
			// Loop over the query.
			for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
	
				// Create a row structure.
				LOCAL.Row = StructNew();
	
				// Loop over the columns in this row.
				for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
	
					// Get a reference to the query column.
					LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
	
					// Store the query cell value into the struct by key.
					LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
	
				}
	
				// Add the structure to the query array.
				ArrayAppend( LOCAL.QueryArray, LOCAL.Row );
	
			}
	
			// Return the array equivalent.
			return( LOCAL.QueryArray );
	
		</cfscript>
	</cffunction>

</cfcomponent>
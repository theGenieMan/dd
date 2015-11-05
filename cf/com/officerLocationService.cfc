<cfcomponent output="false">

    <cffunction name="initVars" description="initialises db sources etc.." access="remote" returntype="struct" >
    	
    	<cfset var serviceVars=structNew()>
    	
    	<cfif SERVER_NAME IS "127.0.0.1" OR SERVER_NAME IS "localhost">   		
    		<cfset serviceVars.WAREHOUSE_DB="wmercia">    		
    	<cfelseif SERVER_NAME IS "development.intranet.wmcpolice">
    	
    	<cfelseif SERVER_NAME IS "websvr.intranet.wmcpolice">	
    		
    	</cfif>
    	
    	<cfreturn serviceVars>
    	
    </cffunction>
    
    <cffunction name="getLocation"
                access="remote"
                returntype="struct" 
                returnformat="JSON">
                
         <cfargument name="officerCollar" type="string" required="true" hint="collar number of officer" />
         <cfargument name="officerForce" type="string" required="true" hint="force of officer" />
         <cfargument name="dateToFind" type="string" required="true" hint="date to find location for" />
         <cfargument name="timeToFind" type="string" required="true" hint="time to find location for" />
         
         <cfset var officerLocationData=structNew()>
         <cfset var qWMQuery="">
         <cfset var qWQuery="">
         
         <cfset officerLocationData.gridRef='333333444444'>
         <cfset officerLocationData.lpa='D'>
         <cfset officerLocationData.beatCode='DA01'>
         <cfset officerLocationData.force='22'>
         
         <cfreturn officerLocationData>       
                
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
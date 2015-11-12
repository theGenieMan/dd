<cfcomponent output="false">

    <cffunction name="initVars" description="initialises db sources etc.." access="remote" returntype="struct" >
    	
    	<cfset var serviceVars=structNew()>
    	
    	<cfif SERVER_NAME IS "127.0.0.1" OR SERVER_NAME IS "localhost">   		
    		<cfset serviceVars.WAREHOUSE_DB="wmercia">  
    		<cfset serviceVars.ENV="localDev">  		
    	<cfelseif SERVER_NAME IS "development.intranet.wmcpolice">
    	    <cfset serviceVars.WAREHOUSE_DB="wmercia">
    	    <cfset serviceVars.ENV="wmDev">    
    	<cfelseif SERVER_NAME IS "websvr.intranet.wmcpolice">	
    		
    	</cfif>

    	<cfreturn serviceVars>
    	
    </cffunction>
    
    <cffunction name="getCustodies"
                access="remote"
                returntype="array" 
                returnformat="JSON">
                    
        <cfset var fnVars=initVars()>
        <cfset var arrCust=arrayNew(1)>    
		<cfset var qCust=''>		
		<cflog file="custService" type="information" text="running get custodies" />
		<cfquery name="qCust" datasource="#fnVars.WAREHOUSE_DB#" result="qCustRes">
			SELECT CUSTODY_REF, SUBSTR(CUSTODY_REF,0,4) AS CUST_SUITE,
			       NOMINAL_REF, NAME AS NOMINAL_NAME,
                   TO_CHAR(DOB,'DD/MM/YYYY') AS DOB, 
                   floor(MONTHS_BETWEEN(sysdate,DOB)/12) AS AGE,
                   ETHNIC_APP, AO_FORCE, AO_BADGE, SEX, 
                   TO_CHAR(ARREST_TIME,'DD-MON HH24:MI') AS ARREST_TIME
           FROM    browser_owner.CUSTODY_SEARCH
           <cfif fnVars.ENV IS NOT "localDev">
           WHERE   ARREST_TIME > SYSDATE-1
           </cfif>
           ORDER   BY ARREST_TIME DESC
		</cfquery>
		<cflog file="custService" type="information" text="#qCUst.recordCount# rows returned. #qCustRes.sql#" />
        <cfreturn QueryToArray(qCust)>
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
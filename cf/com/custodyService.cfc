<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="custodyService">
		<cfargument name="WAREHOUSE_DB" type="string" hint="datasource of data warehouse" required="true" />
				
		<cfset variables.WAREHOUSE_DB = arguments.WAREHOUSE_DB />
		
		<cfset variables.version="1.0.0.0">    
   	    <cfset variables.dateServiceStarted=DateFormat(now(),"DD-MMM-YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>		
		
		<cfreturn this/>
		
	</cffunction>
        
    <cffunction name="getCustodies"
                access="remote"
                returntype="array" 
                returnformat="JSON">
                            
        <cfset var arrCust=arrayNew(1)>    
		<cfset var qCust=''>		
		<cflog file="custService" type="information" text="running get custodies" />
		<cfquery name="qCust" datasource="#variables.WAREHOUSE_DB#" result="qCustRes">
            SELECT cs.CUSTODY_REF, SUBSTR(cs.CUSTODY_REF,0,4) AS CUST_SUITE,
                   cs.NOMINAL_REF, NAME AS NOMINAL_NAME,
                   TO_CHAR(DOB,'DD/MM/YYYY') AS DOB, 
                   floor(MONTHS_BETWEEN(sysdate,DOB)/12) AS AGE,
                   ETHNIC_APP, AO_FORCE, AO_BADGE, SEX, 
                   TO_CHAR(ARREST_TIME,'DD-MON HH24:MI') AS ARREST_TIME,
                   cd.AO_NAME, 
                   TO_CHAR(DECODE(ND.ETHNICITY_6,'NORTH EUROPEAN - WHITE','1',
                                         'WHITE EUROPEAN','1',
                                         'SOUTH EUROPEAN - WHITE','2',
                                         'BLACK','3',
                                         'ASIAN','4',
                                         'CHINESE, JAPANESE OR SE ASIAN','5',
                                         'MIDDLE EASTERN','6',
                                         'UNKNOWN','0',
                                         NULL,'')) AS ETHNICITY_6, 
                   DECODE(ND.ETHNICITY_16,'WHITE - BRITISH','W1',
                                          'WHITE - IRISH','W2',
                                          'WHITE - ANY OTHER WHITE BACKGROUND','W9',
                                          'ASIAN - INDIAN','A1',
                                          'ASIAN - PAKISTANI','A2',
                                          'ASIAN - BANGLADESHI','A3',
                                          'ASIAN - ANY OTHER ASIAN BACKGROUND','A9',
                                          'BLACK - CARIBBEAN','B1',
                                          'BLACK - AFRICAN','B2',
                                          'BLACK - ANY OTHER BLACK BACKGROUND','B9',
                                          'OTHER - CHINESE','O1',
                                          'MIXED - WHITE AND BLACK CARIBBEAN','M1',
                                          'MIXED - WHITE AND BLACK AFRICAN','M2',
                                          'MIXED - WHITE AND ASIAN','M3',
                                          'MIXED - ANY OTHER MIXED BACKGROUND','M9',
                                          'OTHER - ANY OTHER ETHNIC GROUP','O9',
                                          NULL,'',
                                          '') AS ETHNICITY_16
           FROM    browser_owner.CUSTODY_SEARCH cs, browser_owner.CUSTODY_DETAIL cd,
                   browser_owner.NOMINAL_DETAILS nd
           WHERE (1=1)
           AND    cs.CUSTODY_REF=cd.CUSTODY_REF
           AND    cs.NOMINAL_REF=nd.NOMINAL_REF
           <cfif fnVars.ENV IS NOT "localDev">
           AND   ARREST_TIME > SYSDATE-4
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
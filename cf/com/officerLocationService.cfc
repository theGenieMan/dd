<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="officerLocationService">
		<cfargument name="WAREHOUSE_DB" type="string" hint="datasource of data warehouse" required="true" />
		<cfargument name="WAREHOUSE_DB_PREFIX" type="string" hint="prefix of user tables in warehouse" required="true" />
		<cfargument name="LOCATION_DB" type="string" hint="datasource of west mercia location data" required="true" />
		<cfargument name="LOCATION_DB_PREFIX" type="string" hint="prefix of user for west mercia location data" required="true" />
		<cfargument name="STORM_DB" type="string" hint="datasource of STORM database for warks location data" required="true" />				
				
		<cfset variables.WAREHOUSE_DB = arguments.WAREHOUSE_DB />
		<cfset variables.WAREHOUSE_DB_PREFIX = arguments.WAREHOUSE_DB_PREFIX />
		<cfset variables.LOCATION_DB = arguments.LOCATION_DB />
		<cfset variables.LOCATION_DB_PREFIX = arguments.LOCATION_DB_PREFIX />
		<cfset variables.STORM_DB = arguments.STORM_DB />		
		
		<cfset variables.version="1.0.0.0">    
   	    <cfset variables.dateServiceStarted=DateFormat(now(),"DD-MMM-YYYY")&" "&TimeFormat(now(),"HH:mm:ss")>		
		
		<cfreturn this/>
		
	</cffunction>
    
    <cffunction name="getLocation"
                access="remote"
                returntype="struct">
                
         <cfargument name="officerCollar" type="string" required="true" hint="collar number of officer" />
         <cfargument name="officerForce" type="string" required="true" hint="force of officer" />
         <cfargument name="dateToFind" type="date" required="true" hint="date to find location for" />
         <cfargument name="timeToFind" type="date" required="true" hint="time to find location for" />
         
         <cfset var officerLocationData=structNew()>
         <cfset var qWMQuery="">
         <cfset var qWQuery="">
         <cfset var qBeatQuery="">         
         <cfset var sWMCollar=NumberFormat(arguments.officerCollar,'0000')>
         <cfset var sWCollar=NumberFormat(arguments.officerCollar,'0000')>       
         <cfset var warksDateYear=ListGetAt(arguments.dateToFind,3,"/")>
         <cfset var warksDateMonth=ListGetAt(arguments.dateToFind,2,"/")>
         <cfset var warksDateDay=ListGetAt(arguments.dateToFind,1,"/")>
         <cfset var warksDate=warksDateYear & warksDateMonth & warksDateDay>
         <cfset var warksTime=Replace(timeToFind,":","","ALL")&"00">
         <cfset var listDistances="100,250,500,1000,2000">
         
         <cflog file="ols" type="information" text="date = #dateToFind# #timeToFind# officer collar = #sWMCollar#" >
         
         <cfset officerLocationData.locationAvailable=false>
         <cfset officerLocationData.gridAvailable=false>
         <cfset officerLocationData.gridRef=''>
         <cfset officerLocationData.X=''>
         <cfset officerLocationData.Y=''>
         <cfset officerLocationData.lpa=''>
         <cfset officerLocationData.beatCode=''>
         <cfset officerLocationData.force=''>
         <cfset officerLocationData.foundDistance=''>
         
         <!--- try and find person location from West Mercia ARLS 
         	   if the officerForce is 23 (warks) then their call sign needs to be prefixed with the force code
         	   west mercia officers no prefix is required
         --->
         <cfif arguments.officerForce IS "23">
         	<cfset sWMCollar = "23"&sWMCollar>
         </cfif>
         <cfquery name="qWMQuery" datasource="#variables.LOCATION_DB#" maxrows="1">
			SELECT  av.TIME_TO, av.X, av.Y, av.X||av.Y AS GRIDREF, CALLSIGN
			FROM    #variables.LOCATION_DB_PREFIX#APLS_STAFF_AVIS_HIST_VIEW av
			WHERE   CALLSIGN = <cfqueryparam value="#sWMCollar#" cfsqltype="cf_sql_varchar">
			AND     (TIME_FROM < TO_DATE('#dateToFind# #timeToFind#','DD/MM/YYYY HH24:MI:SS') AND TIME_TO > TO_DATE('#dateToFind# #timeToFind#','DD/MM/YYYY HH24:MI:SS'))         	
         </cfquery>
         
         <cfif qWMQuery.recordCount GT 0>
         	<!--- got data from west mercia arls populate the grid ref and set available to true,
         	      as we have found location no need to try warks arls --->
         	<cfset officerLocationData.gridRef=qWMQuery.GRIDREF>
         	<cfset officerLocationData.X=qWMQuery.X>
         	<cfset officerLocationData.Y=qWMQuery.Y>
         	<cfset officerLocationData.gridAvailable=true>
         <cfelse>
            <!--- got nothing from west mercia arls, so try warks 
                  west mercia collars need to be prefixed with 22
                  warks collar no prefix --->
                  
              <cfquery name="qWQuery" datasource="#variables.STORM_DB#" maxrows="1">
			  	SELECT SUBSTR(AVL_DESC,1,4) AS CALLSIGN, MOD_TIME AS TIME_TO,           
			           EASTING||NORTHING AS GRIDREF, EASTING AS X, NORTHING AS Y,
			           abs((to_date(MOD_TIME,'HH24MISS')-to_date('#warksTime#','HH24MISS'))*24*60*60) AS DIFF
				FROM   AVL_UPDATE 
				WHERE  SUBSTR(AVL_DESC,1,4) = '#sWCollar#' 
				AND    MOD_DATE = '#warksDate#'
				AND    to_date('#warksTime#','HH24MISS')  between to_date(MOD_TIME,'HH24MISS')-0.0070
				             AND     to_date(MOD_TIME,'HH24MISS')+0.0070
				ORDER BY abs((to_date(MOD_TIME,'HH24MISS')-to_date('#warksTime#','HH24MISS'))*24*60*60)    
			  </cfquery> 
			  
			  <cfif qWQuery.recordCount GT 0>
			  	<cfset officerLocationData.gridRef=qWQuery.GRIDREF>
			  	<cfset officerLocationData.X=qWQuery.X>
         		<cfset officerLocationData.Y=qWQuery.Y>
         		<cfset officerLocationData.gridAvailable=true> 
			  </cfif>
            
         </cfif>
        
         	
         <cfif officerLocationData.gridAvailable>
         	
         	<cflog file="ols" type="information" text="from #officerLocationData.gridRef# #officerLocationData.X# #officerLocationData.Y#" >
         		
         	<!--- grid ref available, try and find beat code 
         		  loop round gradually extended the search distances
         		  until we get some hits
         	--->        	
         	         	
         	<cfloop list="#listDistances#" index="iDistance" delimiters=",">
         		
         	  <cfset xLow=int(officerLocationData.X)-int(iDistance)>
         	  <cfset xHigh=int(officerLocationData.X)+int(iDistance)>
			  <cfset yLow=int(officerLocationData.Y)-int(iDistance)>
         	  <cfset yHigh=int(officerLocationData.Y)+int(iDistance)>
         		
	         	<cfquery name="qBeatQuery" datasource="#variables.WAREHOUSE_DB#" result="Z">
	         		SELECT DISTINCT BEAT_CODE, DESCRIPTION FROM
					(
					SELECT BEAT_CODE, DESCRIPTION, GRID_REF, ABS(#officerLocationData.X#-SUBSTR(GRID_REF,0,6)) AS DIFF1, ABS(#officerLocationData.Y#-SUBSTR(GRID_REF,7,6)) AS DIFF2, 
					       SQRT(  ABS(#officerLocationData.X#-SUBSTR(GRID_REF,0,6))*ABS(#officerLocationData.X#-SUBSTR(GRID_REF,0,6)) +  ABS(#officerLocationData.Y#-SUBSTR(GRID_REF,7,6))*ABS(#officerLocationData.Y#-SUBSTR(GRID_REF,7,6))  ) AS DIST
					FROM #variables.WAREHOUSE_DB_PREFIX#OFFENCE_SEARCH os, #variables.WAREHOUSE_DB_PREFIX#ORG_LOOKUP org
					WHERE SUBSTR( OS.GRID_REF ,0,6) BETWEEN '#xLow#' AND '#xHigh#'
					  AND SUBSTR( OS.GRID_REF ,7,6) BETWEEN '#yLow#' AND '#yHigh#'
					  AND BEAT_CODE IS NOT NULL
					  AND os.BEAT_CODE=org.ORG_CODE
					  AND org.ORG_TYPE='BTS'
					ORDER BY SQRT(  ABS(#officerLocationData.X#-SUBSTR(GRID_REF,0,6))*ABS(#officerLocationData.X#-SUBSTR(GRID_REF,0,6)) +  ABS(#officerLocationData.Y#-SUBSTR(GRID_REF,7,6))*ABS(#officerLocationData.Y#-SUBSTR(GRID_REF,7,6))  ))
					WHERE ROWNUM <= 10
	         	</cfquery>
	         	                  	
	         	<cfif qBeatQuery.recordCount GT 0>
	         		<cfset officerLocationData.locationAvailable=true>
	         		<cfset officerLocationData.beatCode=ValueList(qBeatQuery.BEAT_CODE)>
	         		<cfset officerLocationData.beatName=ValueList(qBeatQuery.DESCRIPTION)>
	         		<cfset officerLocationData.lpa=Left(qBeatQuery.BEAT_CODE,1)>
	         		<cfif officerLocationData.lpa IS "N" OR officerLocationData.lpa IS "S">
	         			<cfset officerLocationData.force="23">
	         		<cfelse>
	         		    <cfset officerLocationData.force="22">
	         		</cfif>
	         		<!--- find some data, stop looking! --->
	         		<cfset officerLocationData.foundDistance=iDistance>
	         		<cfbreak>
	         	</cfif>
         	</cfloop>
         	
         </cfif>
         
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
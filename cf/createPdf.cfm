<cfquery name="qSub" datasource="DrugDriveNew">
	SELECT *
	FROM   FF_OWNER.DRUG_DRIVE
</cfquery>	

<cfset x=1>
<cfloop query="qSub">
	
<cfset theDir="\\svr20284\d$\assets\drugDrive\"&DateFormat(DATE_INITIAL_STOP,"YYYY")&"\">

<cfif not directoryExists(theDir)>
 <cfdirectory action="create" directory="#theDir#">
</cfif>

<cfset filename=Replace(WWM_URN,"/","_","ALL")&".pdf">
<cfset fullFile=theDir&filename>	

<cfset doPDF(WWM_DD_ID,fullFile)>

</cfloop>

<cffunction name="doPDF">
	<cfargument name="WWM_DD_ID">
	<cfargument name="filename">
	
	<cfquery name="qSub" datasource="DrugDriveNew">
	SELECT *
	FROM   FF_OWNER.DRUG_DRIVE
	WHERE  WWM_DD_ID = #WWM_DD_ID#
	</cfquery>	

    <cfloop query="qSub">
	<cfdocument format="PDF" orientation="portrait" pagetype="A4" margintop="0.75" filename="#filename#" overwrite="true">
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
			   	#WWM_ETHNIC_6#
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
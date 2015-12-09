<cfquery name="qOldData" datasource="drugDriveAccessLive">
	SELECT *
	FROM drugDrive
</cfquery>

<!---
<cfdump var="#qOldData#">
--->

<cfloop query="qOldData">

<cfquery name="qNextDD" datasource="DrugDriveNewLive">
	select DD_ID_SEQ.NEXTVAL AS NEW_DD_ID from DUAL
</cfquery>

<cfif ListFind('C,D,E,F,G',Div) GT 0>
	<cfset theForce='22'>
<cfelse>
    <cfset theForce='23'>
</cfif>

<cfif Outcome4 IS "Y" or Outcome5a IS "Y">
	<cfset arrested='Y'>
<cfelse>
    <cfset arrested='N'>
</cfif>

<cfset drugs="">
<cfif Cannabis IS "Y">
<cfset drugs=ListAppend(drugs,"Cannabis",",")>
</cfif>

<cfif Cocaine IS "Y">
<cfset drugs=ListAppend(drugs,"Cocaine",",")>
</cfif>

<cfset newUrn="DRUGDRIVE/"&theForce&"/"&Div&"/"&Serial&"/"&Year>

<cfoutput>	
<cfsavecontent variable="qLoadInsert">
INSERT INTO FF_OWNER.DRUG_DRIVE
(
  WWM_DD_ID,
  WWM_URN,
  WWM_SERIAL_NO,
  WWM_YEAR,
  WWM_OFFICER_UID,
  WWM_OFFICER_FORCE,
  WWM_OFFICER_COLLAR,
  WWM_OFFICER_NAME,
  WWM_OFFICER_EMAIL,
  WWM_TEST_FORCE,
  POLICE_FORCE_CODE,
  WWM_TEST_LPA,
  WWM_TEST_GRIDREF,
  WWM_TEST_LOCATION,
  WWM_DATE_CREATED,
  DATE_INITIAL_STOP,
  TIME_INITIAL_STOP,
  WWM_TEST_REASON,
  ARRESTED,
  RTC,  
  ROADSIDE_FIT_DONE,  
  <cfif DrugSwipe IS "Y">
  <cfif TestLocation IS "Roadside">
  ROADSIDE_SALVIA_DONE,
  ROADSIDE_SALIVA_RESULT,
  ROADSIDE_SALIVA_DRUG,
  ARRESTED_FOR_S4DRUGS,
  ARRESTED_FOR_S5DRUGS,
  </cfif>
  <cfif TestLocation IS "Station">
  STATION_SALIVA_DONE,
  STATION_SALIVA_RESULT,
  STATION_SALIVA_DRUG,	
  INVESTIGATION_FOR_S4DRUGS,
  INVESTIGATION_FOR_S5DRUGS,
  </cfif>
  <cfif TestLocation IS "Hospital">
  HOSPITAL_SALIVA_DONE,
  HOSPITAL_SALIVA_RESULT,
  HOSPITAL_SALIVA_DRUG	
  </cfif>
  </cfif>
  TEST_REF,
  ADDITIONAL_INFORMATION,
  GENDER,
  AGE,
  ETHICITY,
  WWM_OFF_ETHNICITY,
  DATE_SENT_TO_HO
)	
VALUES
(
  #qNextDD.NEW_DD_ID#,
  '#newURN#',
  #Serial#,
  '#Year#',
  '#CreatedBy#',
  '#OfficerForce#',
  '#OfficerCollar#',
  '#CreatedByName#',
  '#CreatedByEmail#',
  '#theForce#',
  '#theForce#',
  '#Div#',
  '#GridRef#',
  '#TestLocation#',
  TO_DATE('#DateFormat(DateCreated,'DD/MM/YYYY')# #TimeFormat(DateCreated,"HH:mm:ss")#','DD/MM/YYYY HH24:MI:SS'), 	
  TO_DATE('#DateFormat(IncDateTime,'DD/MM/YYYY')#','DD/MM/YYYY'),  
  '#TimeFormat(IncDateTime,'HH:mm')#',
  '#testReason#',
  '#arrested#',
  '#iif(rtc IS "Y",de('Y'),de('N'))#',
   '#FIT#',
  '#iif(drugSwipe IS "Y",de('Y'),de('N'))#',
  '#iif(Cannabis IS "Y" OR Cocaine IS "Y",de('Positive'),de('Negative'))#',
  '#drugs#',
  <cfif testLocation IS NOT "Hospital">
  '#Outcome4#',
  '#Outcome5a#',	
  </cfif>
  '#batchNo#',
  '#Replace(Notes,"'","`","ALL")#',
  '#Left(Sex,1)#',
  '#Age#',
  '#ListGetAt(SelfDefinedEthCode,1,",")#',
  '#ListGetAt(OffDefinedEthCode,1,",")#',
  SYSDATE
)
</cfsavecontent>
</cfoutput>

<cfoutput>
<h1>#ID#</h1>
<cfquery name="qInsert" datasource="DrugDriveNewLive">
INSERT INTO FF_OWNER.DRUG_DRIVE
(
  WWM_DD_ID,
  WWM_URN,
  WWM_SERIAL_NO,
  WWM_YEAR,
  WWM_OFFICER_UID,
  WWM_OFFICER_FORCE,
  WWM_OFFICER_COLLAR,
  WWM_OFFICER_NAME,
  WWM_OFFICER_EMAIL,
  WWM_TEST_FORCE,
  POLICE_FORCE_CODE,
  WWM_TEST_LPA,
  WWM_TEST_GRIDREF,
  WWM_TEST_LOCATION,
  DATE_GENERATED,
  DATE_INITIAL_STOP,
  TIME_INITIAL_STOP,
  WWM_TEST_REASON,
  ARRESTED,
  RTC,
  <cfif Fit IS "Y">
  ROADSIDE_FIT_DONE,
  </cfif>
  <cfif TestLocation IS "Roadside">
  ROADSIDE_SALIVA_DONE,
  ROADSIDE_SALIVA_RESULT,
  ROADSIDE_SALIVA_DRUG,
  ARRESTED_FOR_S4DRUGS,
  ARRESTED_FOR_S5DRUGS,
  </cfif>
  <cfif TestLocation IS "Station">
  STATION_SALIVA_DONE,
  STATION_SALIVA_RESULT,
  STATION_SALIVA_DRUG,	
  INVESTIGATION_FOR_S4DRUGS,
  INVESTIGATION_FOR_S5DRUGS,
  </cfif>
  <cfif TestLocation IS "Hospital">
  HOSPITAL_SALIVA_DONE,
  HOSPITAL_SALIVA_RESULT,
  HOSPITAL_SALIVA_DRUG,	
  </cfif>
  TEST_REF,
  ADDITIONAL_INFORMATION,
  GENDER,
  AGE,
  ETHICITY,
  WWM_ETHNIC_6,
  DATE_SENT_TO_HO
)	
VALUES
(
  #qNextDD.NEW_DD_ID#,
  '#newURN#',
  #Serial#,
  '#Year#',
  '#CreatedBy#',
  '#OfficerForce#',
  '#OfficerCollar#',
  '#CreatedByName#',
  '#CreatedByEmail#',
  '#theForce#',
  '#theForce#',
  '#Div#',
  '#GridRef#',
  '#TestLocation#',
  TO_DATE('#DateFormat(DateCreated,'DD/MM/YYYY')# #TimeFormat(DateCreated,"HH:mm:ss")#','DD/MM/YYYY HH24:MI:SS'), 	
  TO_DATE('#DateFormat(IncDateTime,'DD/MM/YYYY')#','DD/MM/YYYY'),  
  '#TimeFormat(IncDateTime,'HH:mm')#',
  '#testReason#',
  '#arrested#',
  '#iif(rtc IS "Y",de('Y'),de('N'))#',
     <cfif Fit IS "Y">
   'Y',
  </cfif>
  '#iif(drugSwipe IS "Y",de('Y'),de('N'))#',
  '#iif(Cannabis IS "Y" OR Cocaine IS "Y",de('Positive'),de('Negative'))#',
  '#drugs#',
  <cfif testLocation IS NOT "Hospital">
  '#Outcome4#',
  '#Outcome5a#',	
  </cfif>
  '#batchNo#',
  '#Replace(Notes,"'","`","ALL")#',
  '#Left(Sex,1)#',
  '#Age#',
  '#ListGetAt(SelfDefinedEthCode,1,",")#',
  '#ListGetAt(OffDefinedEthCode,1,",")#',
  SYSDATE
)
</cfquery>

</cfoutput>

</cfloop>
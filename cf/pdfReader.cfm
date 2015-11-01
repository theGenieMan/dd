<cfpdfform action="read" source="pdfTemplates/hoDrugDriveFormV1.pdf" result="thePdf" />
	
<cfdump var="#thePdf#" >

<cfpdfform action="populate" source="pdfTemplates/hoDrugDriveFormV1.pdf"
           destination="pdfTemplates/#dateFormat(now(),'YYYYMMDD')##TimeFormat(now(),'HHmmss')#.pdf" >
	
	<cfpdfformparam name="Additional_Information" value="This is a test form from Warwickshire & West Mercia Police" />
	<cfpdfformparam name="Age" value="41" />
	<cfpdfformparam name="Arrested" value="On" />
	<cfpdfformparam name="Arrested_for_DrugsOrAlc" value="On" />
	<cfpdfformparam name="Arrested_for_Failure" value="On" />
	<cfpdfformparam name="Arrested_for_S4Alc" value="On" />
	<cfpdfformparam name="Arrested_for_S4Drugs" value="On" />
	<cfpdfformparam name="Arrested_for_S5Alc" value="On" />
	<cfpdfformparam name="Arrested_for_S5Drugs" value="On" />
	<cfpdfformparam name="Arrested_for_other" value="Arrested Other" />
	<cfpdfformparam name="Blood_Doctor" value="On" />
	<cfpdfformparam name="Blood_Nurse" value="On" />
	<cfpdfformparam name="Blood_failure_reason" value="Blood Failure Reason" />
	<cfpdfformparam name="Blood_other" value="Blood Other" />
	<cfpdfformparam name="Blood_provided" value="On" />
	<cfpdfformparam name="Blood_requested" value="On" />
	<cfpdfformparam name="Blood_time" value="20:46" />
	<cfpdfformparam name="Custody_Ref" value="22ZZ/9999/15" />
	<cfpdfformparam name="Date_initial_stop" value="30/10/2015" />
	<cfpdfformparam name="Disposal_AlcOrDrugs" value="On" />
	<cfpdfformparam name="Disposal_Failure" value="On" />
	<cfpdfformparam name="Disposal_Other" value="Disposal Other" />
	<cfpdfformparam name="Disposal_S4Alc" value="On" />
	<cfpdfformparam name="Disposal_S4Drugs" value="On" />
	<cfpdfformparam name="Disposal_S5Alc" value="On" />
	<cfpdfformparam name="Disposal_S5Drugs" value="On" />
	<cfpdfformparam name="Disposal_other_details" value="Disposal Other Details" />
	<cfpdfformparam name="Ethicity" value="O9" />
	<cfpdfformparam name="Gender" value="F" />
	<cfpdfformparam name="Investigation_for_DrugsOrAlc" value="On" />
	<cfpdfformparam name="Investigation_for_Failure" value="On" />
	<cfpdfformparam name="Investigation_for_S4Alc" value="On" />
	<cfpdfformparam name="Investigation_for_S4Drugs" value="On" />
	<cfpdfformparam name="Investigation_for_S5Alc" value="On" />
	<cfpdfformparam name="Investigation_for_S5Drugs" value="On" />
	<cfpdfformparam name="Investigation_for_other" value="Station Other" />
	<cfpdfformparam name="Lab_LGC" value="On" />
	<cfpdfformparam name="Lab_ROAR" value="On" />
	<cfpdfformparam name="Lab_Randox" value="On" />
	<cfpdfformparam name="Lab_other" value="Lab Other" />
	<cfpdfformparam name="RTC" value="On" />
	<cfpdfformparam name="Reason_not_arrested" value="Reason Not Arrested" />
	<cfpdfformparam name="Roadside_Breath_done" value="On" />
	<cfpdfformparam name="Roadside_Breath_time" value="21:09" />
	<cfpdfformparam name="Roadside_Breath_result" value="99" />
	<cfpdfformparam name="Roadside_FIT_done" value="On" />
	<cfpdfformparam name="Roadside_FIT_OK" value="On" />
	<cfpdfformparam name="Roadside_FIT_poor" value="On" />
	<cfpdfformparam name="Roadside_FIT_time" value="21:10" />
	<cfpdfformparam name="Roadside_Saliva_done" value="On" />
	<cfpdfformparam name="Roadside_Saliva_drug" value="Cannabis" />
	<cfpdfformparam name="Roadside_Saliva_result" value="Fail" />
	<cfpdfformparam name="Roadside_Saliva_time" value="21:12" />
	<cfpdfformparam name="Roadside_device_type1" value="On" />
	<cfpdfformparam name="Roadside_device_type2" value="On" />
	<cfpdfformparam name="Roadside_device_type3" value="On" />
	<cfpdfformparam name="Roadside_device_type_other" value="Other Road device" />
	<cfpdfformparam name="Station_Breath_done" value="On" />
	<cfpdfformparam name="Station_Breath_time" value="21:18" />
	<cfpdfformparam name="Station_Breath_result" value="95" />
	<cfpdfformparam name="Station_Breath_date" value="30/10/2015" />
	<cfpdfformparam name="Station_Saliva_done" value="On" />
	<cfpdfformparam name="Station_Saliva_drug" value="Cocaine" />
	<cfpdfformparam name="Station_Saliva_result" value="Fail" />
	<cfpdfformparam name="Station_Saliva_time" value="21:19" />
	<cfpdfformparam name="Station_Saliva_date" value="31/10/2015" />
	<cfpdfformparam name="Station_device_type1" value="On" />
	<cfpdfformparam name="Station_device_type2" value="On" />
	<cfpdfformparam name="Station_device_type3" value="On" />
	<cfpdfformparam name="Station_device_type_other" value="Other Station device" />
	<cfpdfformparam name="Station_hcp_time" value="21:20" />
	<cfpdfformparam name="Station_hcp_date" value="31/10/2015" />
	<cfpdfformparam name="Test_ref" value="123.456" />
	<cfpdfformparam name="Time_initial_stop" value="20:25" />
	<cfpdfformparam name="Urine_Time1" value="21:22" />
	<cfpdfformparam name="Urine_Time2" value="21:23" />
	<cfpdfformparam name="Urine_provided" value="On" />
	<cfpdfformparam name="hcp_assessed" value="On" />
	<cfpdfformparam name="hcp_decision" value="HCP Decision" />
	<cfpdfformparam name="hcp_doctor" value="On" />
	<cfpdfformparam name="hcp_nurse" value="On" />
	<cfpdfformparam name="hcp_other" value="HCP Other" />
	<cfpdfformparam name="hcp_referral" value="On" />
	<cfpdfformparam name="Medical_defence_Claimed" value="On" />
	<cfpdfformparam name="Medical_defence_drugs" value="Medical Defence" />
	<cfpdfformparam name="Police_Force_Code" value="22" />
	
</cfpdfform>
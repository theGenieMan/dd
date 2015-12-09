<cfquery name="qSub" datasource="#application.dsn#">
	SELECT WWM_DD_ID, WWM_URN, TO_CHAR(DATE_INITIAL_STOP,'DY DD-MON-YYYY') AS DATE_INITIAL_STOP, TIME_INITIAL_STOP
	FROM   FF_OWNER.DRUG_DRIVE
	WHERE  DATE_SENT_TO_HO IS NULL
    AND    DATE_INITIAL_STOP > '07-DEC-2015'
    AND    WWM_URN IS NOT NULL
    ORDER BY WWM_DD_ID
</cfquery>	

<cfoutput>
<cfsavecontent variable="dftSentReport">
=================================================================================================================
DFT Drug Drive Submission - Sent Report	
#DateFormat(now(),'DDD DD/MM/YYYY')# #TimeFormat(now(),'HH:mm')#

The following will be sent:
</cfsavecontent>
</cfoutput>	

<cfset arrFilesCreated=arrayNew(1)>
<cfset i=1>
<cfloop query="qSub">

	<cfset pdfCreated = application.drugDriveService.createDDPDF(DD_ID=WWM_DD_ID)>
	
	<cfoutput>
	<a href="file://#pdfCreated.pdfPath##pdfCreated.pdfFile#">View The PDF</a>
	</cfoutput>
	
	<cfset arrFilesCreated[i]=structNew()>
	<cfset arrFilesCreated[i].file=pdfCreated.pdfPath&pdfCreated.pdfFile>
	<cfset arrFilesCreated[i].ddId=WWM_DD_ID>
	<cfset arrFilesCreated[i].urn=WWM_URN>
	
	<cfset dftSentReport &= WWM_URN & " - " & DATE_INITIAL_STOP & " " & TIME_INITIAL_STOP & " | ID= " & WWM_DD_ID & " | File : " & arrFilesCreated[i].file & chr(10)>

	<cfset i++>
</cfloop>

<cfset dftSentReport &= chr(10) & chr(10)>

<cfdump var="#arrFilesCreated#">

<cfset totalEmails=Round(arrayLen(arrFilesCreated) / 2)>

<cfset iEmailCount=1>
<cfoutput>
<cfloop from="1" to="#arrayLen(arrFilesCreated)#" index="z">
	
	<!--- 2 pdfs required per email, so only look to send every 2nd created pdf
	      check if we have enough pdfs in the list to add the 2nd one --->
	
	<cfif z MOD 2 IS 1>
	
		<cfset iNextPDF = z + 1>
		<cfset send2ndPDF = false>
		
		<cfif iNextPDF LTE arrayLen(arrFilesCreated)>
			<cfset send2ndPDF=true>
		</cfif>
		
		Z = #z#<br>
		iNextPDF = #iNextPDF#<br>
		send2ndPDF = #send2ndPDF#<br>
		
		<cfmail to="nick.blackham@westmercia.pnn.police.uk" from="drugDrive@westmercia.pnn.police.uk"
	       subject="Warks / West Mercia Drug Drive - Email #iEmailCount# of #totalEmails# [RESTRICTED]"
		      type="html">
		  <html>
		  	<head>
		  		<style>
		  			body{
		  				font-family:Arial;
						font-size:12pt;
		  			}
		  		</style>
		  	</head>
			<body>
				<h4 align="center">[RESTRICTED]</h4>				
				<p>This is Warks / West Mercia Drug Drive Submission Email #iEmailCount# of #totalEmails#</p>
				<p>#DateFormat(now(),'DDD DD/MM/YYYY')# #TimeFormat(now(),'HH:mm')#</p>
				<p>Attached are #iif(send2ndPDF,de('2'),de('1'))# PDF File(s)<br>
				   #ListLast(arrFilesCreated[z].file,"\")#
				   <cfif send2ndPDF>
				   <br>#ListLast(arrFilesCreated[iNextPDF].file,"\")#	   
				   </cfif>
				<p><b>***** THIS IS AN AUTOMATED EMAIL PLEASE DO NOT REPLY *****</b></p>
				<h4 align="center">[RESTRICTED]</h4>
			</body>
		  </html>
		  <cfmailparam file="#arrFilesCreated[z].file#" disposition="attachment" type="application/pdf"> 	  	  
		  <cfif send2ndPDF>
		  <cfmailparam file="#arrFilesCreated[iNextPDF].file#" disposition="attachment" type="application/pdf">	  
		  </cfif>	  	 
		</cfmail>
		
		<cfset dftSentReport &= "Email #iEmailCount# of #totalEmails# sent" & chr(10)>
		<cfset dftSentReport &= "File(s) #chr(10)# #arrFilesCreated[z].file#">
		<cfif send2ndPDF>
		<cfset dftSentReport &= " #chr(10)# #arrFilesCreated[iNextPDF].file#">	
		</cfif>
		
		<cfset dftSentReport &= chr(10) & chr(10)>
	
	    <cfset iEmailCount++>
	</cfif>
	
</cfloop>

<cfset dftSentReport &= "=================================================================================================================">

<cfset reportFile=application.wmDocDirectory & 'dft\emailReports\' & dateFormat(now(),'DD-MMM-YYY') & '.txt'>

<cffile action="write" file="#reportFile#" output="#dftSentReport#">

<cfmail to="nick.blackham@westmercia.pnn.police.uk" from="drugDrive@westmercia.pnn.police.uk"
	       subject="Warks / West Mercia Drug Drive - Weekly Email Report">
#dftSentReport#
</cfmail>
</cfoutput>		    
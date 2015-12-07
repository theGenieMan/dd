<cfdump var="#application.drugDriveService#">

<cfdump var="#application.drugDriveService.getDbtoPdfLookup('\\svr20200\d$\inetpub\wwwroot\applications\force_forms\dd\cf\com\dbToPdfLookup.txt')#">

<Cfdump var="#application.drugDriveService.getDrugDrive(DD_ID=ddid)#">

<cfset pdfCreated = application.drugDriveService.createDDPDF(DD_ID=ddid)>

<cfoutput>
<a href="file://#pdfCreated.pdfPath##pdfCreated.pdfFile#">View The PDF</a>
</cfoutput>
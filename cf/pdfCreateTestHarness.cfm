<cfset ddService=CreateObject('component','com.drugDriveService')>

<cfdump var="#ddService#">

<cfdump var="#ddService.getDbtoPdfLookup('C:\ColdFusion10\cfusion\wwwroot\drugDrive\cf\com\dbToPdfLookup.txt')#">

<Cfdump var="#ddService.getDrugDrive(DD_ID=1)#">

<cfset pdfCreated = ddService.createDDPDF(DD_ID=1)>

<cfoutput>
<a href="file://#pdfCreated.pdfPath##pdfCreated.pdfFile#">View The PDF</a>
</cfoutput>
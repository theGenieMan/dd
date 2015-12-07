<cfset xlFile=application.drugDriveService.createXl(fromDate,toDate)>

<cfheader name="Content-Disposition" value="attachment; filename=drugDriveReport.xls"> 
<cfcontent type="application/vnd.ms-excel" file="#xlFile#">
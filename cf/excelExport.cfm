<cfset xlFile=application.drugDriveService.exportXl(fromDate,toDate)>

<cfheader name="Content-Disposition" value="attachment; filename=drugDriveExcelExport.xls"> 
<cfcontent type="application/vnd.ms-excel" file="#xlFile#">
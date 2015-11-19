<html>
	<head>
		<title>Drug Drive Submissions</title>
		<link href="/accessibility/home/stylesheet.cfm" rel="stylesheet">
	</head>
	<body>
		<h2 align="center">
			Drug Drive Submissions Manager
		</h2>
		<cfoutput>
		<div>
			Service Version: #application.version#<br>
			Last Started: #application.serviceStarted#<br>
			DB Is: #application.dsn#
			
			<h3><a href="index.cfm?resetApp=true">Reset Services</a></h3>
			
			<cfdump var="#application.custodyService.getVars()#" />
			
		</div>
		</cfoutput>
	</body>
</html>
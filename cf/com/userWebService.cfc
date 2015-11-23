<cfcomponent>

	<cffunction name="getUserDetailsJSON" access="remote" returntype="Struct" returnformat="json" 
				output="false" hint="returns json representation of an admin user">
		
		<cfset var userId=''>
		<cfset var user=''>
		<cfset var userInfo=structNew()>
		
		<cfif SERVER_NAME IS "127.0.0.1" OR SERVER_NAME IS "localhost">
			<cfset userInfo.trueUserId='p_wat003'>
			<cfset userInfo.fullName='Con Paul WATERHOUSE 221890 (22)'>			
			<cfset userInfo.email='nick.blackham@westmercia.pnn.police.uk'>
			<cfset userInfo.officerForce='22'>
			<cfset userInfo.officerCollar='1890'>
			<cfset userInfo.isAdmin=true>
		<cfelse>
		
		    <cfset userId=AUTH_USER>
						
			<cfif userId IS "Westmerpolice01\n_bla003">
				<cfset userId="n_bla005">
			</cfif>
			
		    <cfset user=application.hrService.getUserByUID(userId)>
		
			<cfif user.getIsValidRecord()>

				<cfset adminUser=application.drugDriveService.getIsAdminUser(user.getTrueUserId())>
	            
				<cfset userInfo.trueUserId=user.getTrueUserId()>
				<cfset userInfo.fullName=user.getFullName()>			
				<cfset userInfo.email=user.getEmailAddress()>
				<cfset userInfo.officerForce=user.getForceCode()>
				<cfset userInfo.officerCollar=user.getCollar()>
				<cfset userInfo.isAdmin=adminUser>
				
			<cfelse>
				<cfthrow message="User does not have a valid HR Account #userId#" errorcode="HR_UNKNOWN_USER" type="Application">
			</cfif>
		
		</cfif>
		
		<cfreturn userInfo>
		
	</cffunction>

</cfcomponent>
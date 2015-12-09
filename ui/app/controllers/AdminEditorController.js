angular.module('drugDrive')
 .controller('AdminEditorController', ['$scope', '$rootScope', '$filter', 'drugDriveService', function($scope,$rootScope,$filter,ddService){
 	
	$scope.addUser='';
	$scope.resetUserSearch=false;	
	$scope.listReady=false;
  	$scope.searchText='';
  	$scope.pageSize=20;
  	$scope.adminUserListArray=[];
  	$scope.currentPage=1;	
 
	$scope.initList = function(){
  	$scope.listReady=true;
	    
		ddService.getAdminUserList()
		.success(function(data, status, headers){
	  		   	    // the success function wraps the response in data
					// so we need to call data.data to fetch the raw data
					console.log(data);		
					$scope.listData = data;
				    $scope.adminUserListArray = [].concat($scope.listData);								
					$scope.listReady=true;
					console.log('user list data returned');
				}).error(function(data, status, headers, config){
					$rootScope.userError=true;
					console.log('Error aye it: ' + data);
					console.log(status);
				})
				
  	};
  
	$scope.$on('userIsReady', function(event){
	  	$scope.listReady=false;
	    $scope.initList();
	});
	
	$scope.addAdminUser=function(){
		
		if ($scope.addUser.isValidRecord) {
			
			/* see if user id already exists in loaded user list array */
			var foundUser=$filter('filter')($scope.adminUserListArray,$scope.addUser.trueUserId);
			
			// user already in list
			if ( foundUser.length === 1) {
			   $scope.userErrorMessage=foundUser[0].ADMIN_USER_NAME+' is already an Administrator';
			   $scope.resetUserSearch=true;
			}
			// user needs adding
			else
			{			
			   $scope.addUser.addedByUserId=$rootScope.user.userId;
			   $scope.addUser.addedByUserName=$rootScope.user.userName;
	           console.log($scope.addUser);
			   
			   ddService.addAdminUser($scope.addUser)
			   .success(function(data, status, headers){
	  		   	    // the success function wraps the response in data
					// so we need to call data.data to fetch the raw data
					$scope.resetUserSearch=true;
					$scope.initList();
					$scope.userAddedMessage=$scope.addUser.fullName + ' has been added successfully.';
				}).error(function(data, status, headers, config){
					console.log('error aye it!' + data)
				})
				
			}

		}
		else
		{
			$scope.userAddedMessage="";
			$scope.userErrorMessage="You must select a user"
		}
				
	};
	
	$scope.deleteAdminUser=function(user){
		
		var delUser = confirm('Delete ' + user.ADMIN_USER_NAME + ' as an administrator?');
		
		if (delUser){
			
			ddService.deleteAdminUser(user.ADMIN_USER_ID)
				.success(
				  function(data, status, headers){
					$scope.resetUserSearch=true;
					$scope.initList();
					$scope.userAddedMessage=user.ADMIN_USER_NAME  + ' has been deleted successfully.';					
				})
				.error(
					function(data, status, headers, config){
					console.log('error aye it!' + data)	
				})
			
		}
		
	}
 	
 }]);
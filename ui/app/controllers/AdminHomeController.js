angular.module('drugDrive')
 .controller('AdminHomeController', ['$scope', '$rootScope', 'userService', function($scope,$rootScope,userService){
 	
	/*
 	$scope.userReady=false;
	
	$scope.initUser = function(){
		
		userService.getLoggedInUser()
  	       .success(function(data, status, headers){
  		// the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
				console.log(data);		
				$rootScope.userId=data.TRUEUSERID;
				$rootScope.userName=data.FULLNAME;				
				$rootScope.emailAddr=data.EMAIL;
				$rootScope.collar=data.OFFICERCOLLAR;
				$rootScope.force=data.OFFICERFORCE;		
				$scope.userReady=true;
			}).error(function(data, status, headers, config){
				$scope.userError=true;
				console.log('Error aye it: ' + data);
				console.log(status);
			})
		
	}*/
 	
 }]);
angular.module('drugDrive')
  .controller('SubmissionSuccessController', ['$scope', 'drugDriveService','$routeParams',
               function($scope, ddService, routeParams, location) {

	$scope.urnReady=false;
    
	$scope.getUrn = function(){
	
		 ddService.getDD(routeParams.ddId)
  	    .success(function(data, status, headers){
  				// the success function wraps the response in data
				// setup the ddData variable with the information we have got.				
				$scope.URN=data.WWM_URN;	
				$scope.urnReady=true;				
		}).error(function(data, status, heaers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
		})	
		
	};
	  

}]);			   
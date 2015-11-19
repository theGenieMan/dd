angular.module('drugDrive')
  .controller('UserListController', ['$scope', '$rootScope', 'drugDriveService','$routeParams', '$filter',
               function($scope, $rootScope, ddService, routeParams, $filter) {

  $scope.listReady=false;
  $scope.searchText='';
  $scope.pageSize=10;
  $scope.userListArray=[];
  $scope.currentPage=1;	
 
  $scope.initList = function(){
  	
	ddService.getUserDrugDrive($rootScope.user.userId)
	.success(function(data, status, headers){
  		   	    // the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
				console.log(data);		
				$scope.listData = data;
			    $scope.userListArray = [].concat($scope.listData);								
				$scope.listReady=true;
				console.log('user list data returned');
			}).error(function(data, status, headers, config){
				$rootScope.userError=true;
				console.log('Error aye it: ' + data);
				console.log(status);
			})	
  };
  
  $scope.deleteDrugDrive = function(submission){
  	
	var confDel = confirm('Are you sure you want to delete submission id: '+submission.WWM_DD_ID+'\n\n'+submission.WWM_TEST_REASON+'\nOn '+$filter('date')(submission.DATE_INITIAL_STOP_TSTAMP, "dd/MM/yyyy")+' '+submission.TIME_INITIAL_STOP) 
	
	if(confDel){
		ddService.deleteDrugDrive(submission.WWM_DD_ID)
			.success(function(data, status, headers){
  		   	    // the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
				$scope.initList();
			}).error(function(data, status, headers, config){				
				console.log('Error aye it: ' + data);
				console.log(status);
			})	
	}
	
  };

  $scope.$on('userIsReady', function(event){
  	$scope.listReady=false;
    $scope.initList();
  });
	  

}]);			   
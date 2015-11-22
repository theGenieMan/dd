angular.module('drugDrive')
  .controller('AdminListController', ['$scope', '$rootScope', 'drugDriveService','$routeParams', '$filter',
               function($scope, $rootScope, ddService, routeParams, $filter) {

  $scope.listReady=false;
  $scope.searchText='';
  $scope.pageSize=10;
  $scope.adminListArray=[];
  $scope.currentPage=1;	
 
  $scope.initList = function(){
  	
	ddService.getAdminDrugDrive($rootScope.user.userId)
	.success(function(data, status, headers){
  		   	    // the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
				console.log(data);		
				$scope.listData = data;
			    $scope.adminListArray = [].concat($scope.listData);								
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
	  

}]);			   
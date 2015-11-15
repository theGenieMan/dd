angular.module('drugDrive')
 .controller('custodyController', ['$scope', 'custodyService', '$log', function($scope,  custodyService, $log) {
  $scope.person = {
    name: 'HTCU'
  };
  $scope.applicationTitle='The Custody List';
  $scope.usersReady=false;
  $scope.isCollapsed=false;
  $scope.getShit = function(){
  	custodyService.custodyList().success(function(data, status, headers){
  		// the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
				$scope.meData = data;
				$scope.displayData = [].concat($scope.meData);
				$scope.usersReady=true;
				console.log($scope.meData);
			}).error(function(data, status, heaers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
			})
		}
  
}]);
app.directive('custodyListDirective', function() {
  return {
    restrict: 'AE',
    templateUrl : 'app/components/custodyListDirective.html',
    controller: ['$scope','custodyService', function($scope, custodyService){    
    	custodyService.custodyList().success(function(data, status, headers){
  		// the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
			
				$scope.custodyListD = data;
				$scope.custodyListArray = [].concat($scope.custodyListD);				
				console.log($scope.custodyListArray);
			}).error(function(data, status, heaers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
			})		
     }],
    controllerAs : 'cldCtrl'
   }
});

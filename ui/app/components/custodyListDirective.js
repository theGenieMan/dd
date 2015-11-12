angular.module('drugDrive')
 .directive('custodyListDirective', function() {
  return {
    restrict: 'AE',
    templateUrl : 'app/components/custodyListDirective.html',
    controller: ['$scope','custodyService', function($scope, custodyService){   
	
	    $scope.custodyListArray = [];
		
	    $scope.custodyStnList=[
		 {label:'-- Select --', id:''},
		 {label:'Worcester (22CA)', id:'22CA'},
		 {label:'Kidderminster (22DA)', id:'22DA'},
		 {label:'Hereford (22EA)', id:'22EA'},
		 {label:'Shrewsbury (22FA)', id:'22FA'},
		 {label:'Telford (22GA)', id:'22GA'},
		 {label:'Nuneaton (23N2)', id:'23N2'},
		 {label:'Leamington (23S1)', id:'23S1'}
		];
		
		 $scope.pageSize = 10;
		 $scope.currentPage = 1;
  		 $scope.totalItems = 0;
	 
    	custodyService.custodyList().success(function(data, status, headers){
  				// the success function wraps the response in data
				// so we need to call data.data to fetch the raw data	 		    
				$scope.custodyListD = data;
				$scope.custodyListArray = [].concat($scope.custodyListD);	
				console.log(data)							
			}).error(function(data, status, heaers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
			})
			
					
     }],
    controllerAs : 'cldCtrl'
   }
});

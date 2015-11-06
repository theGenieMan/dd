app.controller('drugDriveController', ['$scope', 'officerLocationService', 'drugDriveService' , function($scope, offLS, ddService) {
  
  $scope.applicationTitle='Drug Drive / FIT Test Submission';
  $scope.officerLocationSearchRan=false;
  
  $scope.ddData={
  	DATE_INITIAL_STOP:'29/10/2015',
  	TIME_INITIAL_STOP:'21:33',
  	WWM_OFFICER_UID:'n_bla005',
  	WWM_OFFICER_COLLAR:'4854',
  	WWM_OFFICER_FORCE:'22',
  	WWM_OFFICER_NAME:'Sp Con 4854 Nick BLACKHAM',
  	WWM_OFFICER_EMAIL:'nick.blackham@westmercia.pnn.police.uk',
  	WWM_TEST_LOCATION:''
  };
  
  $scope.CUSTODY_DATA={};
  
  $scope.selectYN=[
  	{label:'-- Select --', id:''},
  	{label:'Yes', id:'Y'},
  	{label:'No', id:'N'}	
  ];
  
  
  $scope.submitDD = function(){
  	
  	alert('submit me form')
  	
  	ddService.submitDD($scope.ddData)
  	       .success(function(data, status, headers){
  		// the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
				console.log(data.DD_ID);
				$scope.ddData.WWM_DD_ID=data.DD_ID;
			}).error(function(data, status, heaers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
			})
  	
  };
  
  $scope.getOfficerLocation = function(){
  	
  	  offLS.getOfficerLocation($scope.ddData.WWM_OFFICER_COLLAR, $scope.ddData.WWM_OFFICER_FORCE, $scope.ddData.DATE_INITIAL_STOP, $scope.ddData.TIME_INITIAL_STOP)
  	       .success(function(data, status, headers){
  		// the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
				$scope.ddData.WWM_TEST_GRIDREF = data.GRIDREF;
				$scope.ddData.WWM_TEST_LPA = data.LPA;
				$scope.ddData.WWM_TEST_BEAT = data.BEATCODE;
				$scope.ddData.WWM_TEST_FORCE = data.FORCE;				
				$scope.officerLocationSearchRan=true;
				console.log($scope.meData);
			}).error(function(data, status, heaers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
			})
  	
  };
  
  $scope.custodyClick = function(custodyData){
  	$scope.CUSTODY_DATA=custodyData;
  };
   
  
}]);
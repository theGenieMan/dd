app.controller('drugDriveController', ['$scope', '$document', 'officerLocationService', 'drugDriveService' , function($scope, $document, offLS, ddService) {
  
   $document.on('keydown', function(e){
          if(e.which === 8 && e.target.nodeName !== "INPUT"){ // you can add others here.
              e.preventDefault();
          }
      });
  
  $scope.applicationTitle='Drug Drive / FIT Test Submission';
  $scope.officerLocationSearchRan=false;
  $scope.calStatus = {
    opened: false
  };
  
  $scope.forceSelect = [
  	{label:'-- Select --', id:''},
  	{label:'Warwickshire Police', id:23},
  	{label:'West Mercia Police', id:22}	
  ];
  
  $scope.lpaSelect = [
  	{label:'-- Select --', id:''},
  	{label:'C - South Worcestershire', id:'C'},
  	{label:'D - North Worcestershire', id:'D'},
  	{label:'E - Herefordshire', id:'E'},
  	{label:'F - Shropshire', id:'F'},
  	{label:'G - Telford &amp; Wrekin', id:'G'},
  	{label:'N - North Warwickshire', id:'N'},
  	{label:'S - South Warwickshire', id:'S'}	
  ]
  
  $scope.testLocation = [
  	{label:'-- Select --', id:''},
  	{label:'Roadside', id:'Roadside'},
  	{label:'Station', id:'Station'},
  	{label:'Hospital', id:'Hospital'}	
  ]

  $scope.overideDate=new Date(2015,9,29,21,33,0,0);
  
  
  $scope.ddData={
  	DATE_INITIAL_STOP_PICKER:$scope.overideDate,
  	TIME_INITIAL_STOP:formatDate($scope.overideDate,'HH:mm'),
  	WWM_OFFICER_UID:'n_bla005',
  	WWM_OFFICER_COLLAR:'4854',
  	WWM_OFFICER_FORCE:'22',
  	WWM_OFFICER_NAME:'Sp Con 4854 Nick BLACKHAM',
  	WWM_OFFICER_EMAIL:'nick.blackham@westmercia.pnn.police.uk',
  	WWM_TEST_LOCATION:'Roadside',
  	ROADSIDE_FIT_DONE: 'Y',
	ARRESTED:'Y'  	
  };
  
  $scope.CUSTODY_DATA={};
  
  $scope.selectYN=[
  	{label:'-- Select --', id:''},
  	{label:'Yes', id:'Y'},
  	{label:'No', id:'N'}	
  ];
  
  
  $scope.submitDD = function(){
  	
	$scope.ddData.DATE_INITIAL_STOP=formatDate($scope.ddData.DATE_INITIAL_STOP_PICKER,'dd/MM/yyyy');
	alert($scope.ddData.DATE_INITIAL_STOP)
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
  	
  	  offLS.getOfficerLocation($scope.ddData.WWM_OFFICER_COLLAR, $scope.ddData.WWM_OFFICER_FORCE, $scope.ddData.DATE_INITIAL_STOP_PICKER, $scope.ddData.TIME_INITIAL_STOP)
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
  
  $scope.openCal = function($event) {
    $scope.calStatus.opened = true;
  };
  
  $scope.custodyClick = function(custodyData){
  	$scope.CUSTODY_DATA=custodyData;
  };
   
  
}]);
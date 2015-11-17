angular.module('drugDrive')
  .controller('DrugDriveController', ['$scope', '$document', 'officerLocationService', 'drugDriveService','$routeParams' , 
               function($scope, $document, offLS, ddService, routeParams) {
  
   $document.on('keydown', function(e){
          if(e.which === 8 && (e.target.nodeName !== "INPUT" && e.target.nodeName !=='TEXTAREA')){ // you can add others here.
              e.preventDefault();
          }
      });
  $scope.ddData = {};		
  $scope.applicationTitle='Drug Drive / FIT Test Submission';
  $scope.officerLocationSearchRan=false;
  $scope.showCustodyList=false;
  $scope.personNext=2;
  $scope.calStatus = {
    opened: false
  };

  $scope.overideDate=new Date(2015,9,29,21,33,0,0);
  
  $scope.$watch('ddData.ARRESTED',
  	function handleArrestedChange(newValue, oldValue){
		if (newValue == 'Y'){
			  $scope.showCustodyList=true;
		}
		else
		{
			  $scope.ddData.CUSTODY_REF='';
			  $scope.ddData.WWM_NOMINAL_REF='';
			  $scope.showCustodyList=false;
		}
	}
  )
  
  $scope.showCustodies = function(){
  	$scope.showCustodyList=true;
  }
  
  $scope.CUSTODY_DATA={};
  
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
  
  $scope.swipeResult = [
  	{label:'-- Select --', id:''},
  	{label:'Positive', id:'Positive'},
  	{label:'Negative', id:'Negative'}	
  ]
  
  $scope.swipeDrugs = [
  	{label:'Cannabis', id:'Cannabis'},
  	{label:'Cocaine', id:'Cocaine'}
	/*
	{label:'Opiates', id:'Opiates'},
	{label:'Amphetamines', id:'Amphetamines'}
	*/	
  ]  
  
  $scope.selectYN=[
  	{label:'-- Select --', id:''},
  	{label:'Yes', id:'Y'},
  	{label:'No', id:'N'}	
  ];

  $scope.gender=[
  	{label:'-- Select --', id:''},
  	{label:'Male', id:'M'},
  	{label:'Female', id:'F'}	
  ];
  
  $scope.ethnic6=[
     {label:'-- Select --', id:''},
	 {label:'NORTH EUROPEAN - WHITE', id:1},
	 {label:'SOUTH EUROPEAN - WHITE', id:2},
	 {label:'BLACK', id:3},
	 {label:'ASIAN', id:4},
	 {label:'CHINESE, JAPANESE OR SE ASIAN', id:5},
	 {label:'MIDDLE EASTERN', id:6},
	 {label:'UNKNOWN', id:0},
  ];
  
  $scope.ethnic16=[
     {label:'-- Select --', id:''},
	 {label:'W1	WHITE - BRITISH', id:'W1'},
	 {label:'W2	WHITE - IRISH', id:'"W2'},
	 {label:'W9	WHITE - ANY OTHER WHITE BACKGROUND', id:'W9'},
	 {label:'A1	ASIAN - INDIAN', id:'A1'},
	 {label:'A2	ASIAN - PAKISTANI', id:'A2'},
	 {label:'A3	ASIAN - BANGLADESHI', id:'A3'},
	 {label:'A9	ASIAN - ANY OTHER ASIAN BACKGROUND', id:'A9'},
	 {label:'B1	BLACK - CARIBBEAN', id:'B1'},
	 {label:'B2	BLACK - AFRICAN', id:'B2'},
	 {label:'B9	BLACK - ANY OTHER BLACK BACKGROUND', id:'B9'},
	 {label:'O1	OTHER - CHINESE', id:'O1'},
	 {label:'M1	MIXED - WHITE AND BLACK CARIBBEAN', id:'M1'},
	 {label:'M2	MIXED - WHITE AND BLACK AFRICAN', id:'M2'},
	 {label:'M3	MIXED - WHITE AND ASIAN', id:'M3'},
	 {label:'M9	MIXED - ANY OTHER MIXED BACKGROUND', id:'M9'},
	 {label:'O9	OTHER - ANY OTHER ETHNIC GROUP', id:'O9'},
	 {label:'NX	NOT STATED - DECLINED ', id:'NX'},
	 {label:'NZ	NOT STATED - NOT UNDERSTOOD ', id:'NZ'}	
  ];  
  
  $scope.loadDD = function(ddId){
  	
	 ddService.getDD(ddId)
  	    .success(function(data, status, headers){
  				// the success function wraps the response in data
				// setup the ddData variable with the information we have got.
				console.log('got me data');	
				console.log(data);	
				$scope.ddData = {};						
				for (var key in data) {
				  console.log(key + ': '+ data[key]);
				  $scope.ddData[key]=data[key];
				};
				if ($scope.ddData['DATE_INITIAL_STOP'].length > 0){
					$scope.ddData.DATE_INITIAL_STOP_PICKER=new Date($scope.ddData['DATE_INITIAL_STOP']);
				};
				if ($scope.ddData['STATION_HCP_DATE'].length > 0){
					$scope.ddData.STATION_HCP_DATE_PICKER=new Date($scope.ddData['STATION_HCP_DATE']);
				};
				$scope.officerLocationSearchRan=true;
		}).error(function(data, status, heaers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
		})	
	
  };
  
  $scope.submitDD = function(){
  	
	$scope.ddData.DATE_INITIAL_STOP=formatDate($scope.ddData.DATE_INITIAL_STOP_PICKER,'dd/MM/yyyy');
	if ($scope.ddData.STATION_HCP_DATE_PICKER){
		$scope.ddData.STATION_HCP_DATE=formatDate($scope.ddData.STATION_HCP_DATE_PICKER,'dd/MM/yyyy');	
	}
	
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
  	$scope.ddData.CUSTODY_REF=custodyData.CUSTODY_REF;
	$scope.ddData.AGE=custodyData.AGE;
	$scope.ddData.GENDER=custodyData.SEX;
	$scope.ddData.ETHICITY=custodyData.ETHNICITY_16;
	$scope.ddData.WWM_OFF_ETHNICITY=custodyData.ETHNICITY_6;
	$scope.ddData.WWM_NOMINAL_REF=custodyData.NOMINAL_REF;
	$scope.showCustodyList=false;
  };

  if (angular.isDefined(routeParams.ddId) ){
  	  $scope.loadDD(routeParams.ddId);
  }
  else{
  	  $scope.ddData={
	  	DATE_INITIAL_STOP_PICKER:$scope.overideDate,
	  	TIME_INITIAL_STOP:formatDate($scope.overideDate,'HH:mm'),
	  	WWM_OFFICER_UID:'n_bla005',
	  	WWM_OFFICER_COLLAR:'4854',
	  	WWM_OFFICER_FORCE:'22',
	  	WWM_OFFICER_NAME:'Sp Con 4854 Nick BLACKHAM',
	  	WWM_OFFICER_EMAIL:'nick.blackham@westmercia.pnn.police.uk',
	  	WWM_TEST_LOCATION:'Station',
		/*
	  	ROADSIDE_FIT_DONE: 'N',
		ROADSIDE_BREATH_DONE: 'N',
		ROADSIDE_SALIVA_DONE: 'Y',
		
		*/
		STATION_SALIVA_RESULT: 'Positive',
		STATION_BREATH_DONE: 'Y',
		ARRESTED:'N'  	
	  };
  }   
  
}]);
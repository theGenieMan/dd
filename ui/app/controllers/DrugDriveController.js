angular.module('drugDrive')
  .controller('DrugDriveController', ['$scope', '$rootScope', '$document', 'drugDriveService','$routeParams' , '$location',
               function($scope, $rootScope, $document, ddService, routeParams, location) {
  
   $document.on('keydown', function(e){
          if(e.which === 8 && (e.target.nodeName !== "INPUT" && e.target.nodeName !=='TEXTAREA')){ // you can add others here.
              e.preventDefault();
          }
      });
  $scope.ddData = {};		
  $scope.applicationTitle='Drug Drive / FIT Test Submission';
  $scope.officerLocationSearchRan=false;
  $scope.officerLocationSearchRunning=false;
  $scope.showCustodyList=false;
  $scope.personNext=2;
  $scope.calStatus = {
    opened: false
  };
  
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
  
  $scope.$watch('ddData.WWM_TEST_REASON',
  	function handleReasonChange(newValue, oldValue){
		if (newValue == 'RTC'){
			  $scope.ddData.RTC='Y';
		}
		else
		{
			  $scope.ddData.RTC='';
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
  
  $scope.$watch('ddData.WWM_TEST_FORCE',
  	function handleReasonChange(newValue, oldValue){
		if (newValue == '22'){
			  $scope.lpaSelect = [
				  	{label:'-- Select --', id:''},
				  	{label:'C - South Worcestershire', id:'C'},
				  	{label:'D - North Worcestershire', id:'D'},
				  	{label:'E - Herefordshire', id:'E'},
				  	{label:'F - Shropshire', id:'F'},
				  	{label:'G - Telford &amp; Wrekin', id:'G'}
			  ];
		}

		if (newValue == '23'){
			  $scope.lpaSelect = [
				{label:'N - North Warwickshire', id:'N'},
			  	{label:'S - South Warwickshire', id:'S'}	
			  ];
		}		

	}
  )  
  
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
  	{label:'Female', id:'F'},	
	{label:'Unknown', id:'U'}	
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
  
  $scope.wwmReason=[
  	{label:'RTC', id:'RTC'},
  	{label:'Moving Traffic Offence',id:'Moving Traffic Offence'},
	{label:'Suspect Impairment Thru Drugs',id:'Suspect Impairment Thru Drugs'},
  	{label:'Suspect OPL in Drugs',id:'Suspect OPL in Drugs'},
	{label:'Other',id:'Other'}
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
				if ($scope.ddData['ROADSIDE_SALIVA_DRUG'].length > 0){					
					var aDrugSplit=$scope.ddData['ROADSIDE_SALIVA_DRUG'].split(',');					
					$scope.ddData.ROADSIDE_SALIVA_DRUG=aDrugSplit;					
				}
				if ($scope.ddData['STATION_SALIVA_DRUG'].length > 0){					
					var aDrugSplit=$scope.ddData['STATION_SALIVA_DRUG'].split(',');					
					$scope.ddData.STATION_SALIVA_DRUG=aDrugSplit;					
				}
				if ($scope.ddData['HOSPITAL_SALIVA_DRUG'].length > 0){					
					var aDrugSplit=$scope.ddData['HOSPITAL_SALIVA_DRUG'].split(',');					
					$scope.ddData.HOSPITAL_SALIVA_DRUG=aDrugSplit;					
				}				
				$scope.officerLocationSearchRan=true;
		}).error(function(data, status, heaers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
		})	
	
  };
  
  $scope.formatDatePickers = function(){
  	$scope.ddData.DATE_INITIAL_STOP=formatDate($scope.ddData.DATE_INITIAL_STOP_PICKER,'dd/MM/yyyy');
	if ($scope.ddData.STATION_HCP_DATE_PICKER){
		$scope.ddData.STATION_HCP_DATE=formatDate($scope.ddData.STATION_HCP_DATE_PICKER,'dd/MM/yyyy');	
	}
	if($scope.ddData.STATION_SALIVA_DONE === 'Y'){
	  $scope.ddData.STATION_SALIVA_DATE=formatDate($scope.ddData.DATE_INITIAL_STOP_PICKER,'dd/MM/yyyy'); 	
	}
	if ($scope.ddData.STATION_BREATH_DONE === 'Y') {
		$scope.ddData.STATION_BREATH_DATE = formatDate($scope.ddData.DATE_INITIAL_STOP_PICKER, 'dd/MM/yyyy');
	}	
  }
  
  $scope.submitDD = function(){
  	
	$scope.formatDatePickers();
	
	if ( $scope.ddData.ROADSIDE_SALIVA_DONE === 'Y' ){
		$scope.ddData.ROADSIDE_DEVICE_TYPE3='Y'
	}
	
	if ( $scope.ddData.STATION_SALIVA_DONE === 'Y' ){
		$scope.ddData.STATION_DEVICE_TYPE3='Y'
	}
	
	$scope.ddData.POLICE_FORCE_CODE=$scope.ddData.WWM_TEST_FORCE;
	
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
  
  $scope.finaliseDD = function(){
  	
  	$scope.formatDatePickers();
  	
  	ddService.submitDD($scope.ddData)
  		.success(
  			function(data, status, headers){
  				ddService.finaliseDD($scope.ddData.WWM_DD_ID)
  				.success(
  					function(data, status, headers){  	
  						location.path('/submissionSuccess/'+$scope.ddData.WWM_DD_ID)  
  					}  					
  				)  	
  				.error
  				(
  					function(data, status, headers, config){
  						console.log('error in finalise')
  					}
  				)
  			}		
  		)
  		.error(
  			function(data, status, headers, config){
  				console.log('error in save')
  					}
  		);
  	
  }
  
  $scope.getOfficerLocation = function(){
  	  $scope.officerLocationSearchRunning=true;
	  $scope.noLocationFound=false;
  	  ddService.locateOfficer($scope.ddData.WWM_OFFICER_COLLAR, $scope.ddData.WWM_OFFICER_FORCE, $scope.ddData.DATE_INITIAL_STOP_PICKER, $scope.ddData.TIME_INITIAL_STOP)
  	       .success(function(data, status, headers){
  				// the success function wraps the response in data
				// so we need to call data.data to fetch the raw data
				$scope.ddData.WWM_TEST_GRIDREF = data.GRIDREF;
				$scope.ddData.WWM_TEST_LPA = data.LPA;
				$scope.ddData.WWM_TEST_BEAT = data.BEATCODE;
				$scope.ddData.WWM_TEST_FORCE = data.FORCE;				
				$scope.officerLocationSearchRan=true;
				$scope.officerLocationSearchRunning=false;
				if ($scope.ddData.WWM_TEST_GRIDREF.length==0){
					$scope.noLocationFound=true;
				}
				console.log($scope.meData);
			}).error(function(data, status, headers, config){
				console.log('Error aye it: ' + data);
				console.log(status);
				$scope.noLocationFound=true;
				$scope.officerSearchRunning=false;
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
	$scope.ddData.WWM_NOMINAL_NAME=custodyData.NOMINAL_NAME;
	$scope.showCustodyList=false;
  };

  $scope.initForm = function(){
    console.log('initForm drugDrive')
  	if (angular.isDefined(routeParams.ddId)) {
  		$scope.loadDD(routeParams.ddId);
  	}
  	else {
  		$scope.ddData = {
  			DATE_INITIAL_STOP_PICKER: new Date(),
  			TIME_INITIAL_STOP: formatDate(new Date(), 'HH:mm'),
  			WWM_OFFICER_UID: $rootScope.userId,
  			WWM_OFFICER_COLLAR: $rootScope.collar,
  			WWM_OFFICER_FORCE: $rootScope.force,
  			WWM_OFFICER_NAME: $rootScope.userName,
  			WWM_OFFICER_EMAIL: $rootScope.emailAddr
  		};
  	}
	
  };
  
  $scope.$on('userIsReady', function(event){
    $scope.initForm();
  });
  
}]);
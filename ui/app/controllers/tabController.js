angular.module('drugDrive')
  .controller('TabController', ['$scope', function($scope) {
	
	$scope.tabs = [
	    { title:'Time / Location', content:'templates/pages/drugDriveForm/timeLocation.html' },
	    { title:'Tests Performed', content:'templates/pages/drugDriveForm/testsPerformed.html' },
	    { title:'Person / Arrest', content:'templates/pages/drugDriveForm/personArrest.html', active: true },
		{ title:'HCP / Blood / Urine', content:'templates/pages/drugDriveForm/hcpBloodUrine.html'},
		{ title:'Disposal', content:'templates/pages/drugDriveForm/disposal.html'},
		{ title:'Additional', content:'templates/pages/drugDriveForm/additionalInfo.html'}
  	];
  
    $scope.$watch('ddData.ARRESTED',
  	function handleArrestedChange(newValue, oldValue){
		if (newValue == 'N'){
			  $scope.personNext=4;
			  $scope.tabs[3].disabled=true;
			  $scope.tabs[4].disabled=true;
		}
		else
		{
			  $scope.personNext=2;
			  $scope.tabs[3].disabled=false;
			  $scope.tabs[4].disabled=false;
		}
	}
  )
  
  $scope.nextTab = function(tabNo){
  	tabNo++;  	
  	$scope.tabs[tabNo].disabled=false;
  	$scope.tabs[tabNo].active=true;
  }
	
}]);
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
  
  $scope.nextTab = function(tabNo){
  	tabNo++;  	
  	$scope.tabs[tabNo].disabled=false;
  	$scope.tabs[tabNo].active=true;
  }
	
}]);
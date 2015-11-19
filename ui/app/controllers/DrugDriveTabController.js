angular.module('drugDrive')
  .controller('DrugDriveTabController', ['$scope', function($scope) {
	
	$scope.tabs = [
	    { title:'Time / Location', content:'templates/pages/drugDriveForm/timeLocation.html', active: true },
	    { title:'Tests Performed', content:'templates/pages/drugDriveForm/testsPerformed.html', disabled: true },
	    { title:'Person / Arrest', content:'templates/pages/drugDriveForm/personArrest.html', disabled: true },
		{ title:'HCP', content:'templates/pages/drugDriveForm/hcp.html', disabled: true},
		{ title:'Blood / Urine', content:'templates/pages/drugDriveForm/bloodUrine.html', disabled: true},
		{ title:'Disposal', content:'templates/pages/drugDriveForm/disposal.html', disabled: true},
		{ title:'Additional', content:'templates/pages/drugDriveForm/additionalInfo.html', disabled: true}
  	];
  
    
  $scope.$watch('ddData.ARRESTED',
  	function handleArrestedChange(newValue, oldValue){		
		if (newValue == 'N'){
			  $scope.personNext=5;
			  $scope.tabs[3].disabled=true;
			  $scope.tabs[4].disabled=true;
			  $scope.tabs[5].disabled=true;
		}
		else
		{
			if (newValue == 'Y') {
				$scope.personNext = 2;
			}  
		}
	}
  )
  
  $scope.nextTab = function(tabNo){
  	tabNo++;  	
  	$scope.tabs[tabNo].disabled=false;
  	$scope.tabs[tabNo].active=true;
  }  
	
}]);
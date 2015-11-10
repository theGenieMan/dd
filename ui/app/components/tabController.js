app.controller('TabController', ['$scope', function($scope) {
	
	$scope.tabs = [
    { title:'Time / Location', content:'app/components/timeLocationDirective.html' },
    { title:'Tests Performed', content:'app/components/testsPerformed.html' },
    { title:'Person / Arrest', content:'app/components/personArrest.html', active: true }
  ];
  
  $scope.nextTab = function(tabNo){
  	tabNo++;
  	alert(tabNo);  	
  	$scope.tabs[tabNo].disabled=false;
  	$scope.tabs[tabNo].active=true;
  }
	
}]);
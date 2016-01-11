angular.module('drugDrive')
 .controller('AdminExcelController', ['$scope', '$rootScope', function($scope,$rootScope){
 	
 	var today=new Date();
 	$scope.startDate=new Date(today.getFullYear(),0,1);
 	$scope.endDate=today;
 	$scope.calStatusStart = {
    	opened: false
  	};
  	$scope.calStatusEnd = {
    	opened: false
  	};
		
	
	$scope.createReport = function(){
		
		var sStartDate=formatDate($scope.startDate,'dd-MMM-yyyy').toUpperCase();
		var sEndDate=formatDate($scope.endDate,'dd-MMM-yyyy').toUpperCase();
		
		window.open('../cf/excelExport.cfm?fromDate='+sStartDate+'&toDate='+sEndDate);
		
	}	
 	
 }]);
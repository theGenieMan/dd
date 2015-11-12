angular.module('drugDrive')
  .factory('officerLocationService', ['$http', function($http) {

    var getOfficerLocation = function(collar, force, dateLocation, timeLocation) {	
          
      var dateToFind = formatDate(dateLocation,'dd/MM/yyyy');
    	  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/officerLocationService.cfc?method=getLocation&officerCollar='+collar+'&officerForce='+force+'&dateToFind='+dateToFind+'&timeToFind='+timeLocation
      });
    }
    return {
      getOfficerLocation: getOfficerLocation
    };
  }]);
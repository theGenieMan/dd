app.factory('officerLocationService', ['$http', function($http) {

    var getOfficerLocation = function(collar, force, dateLocation, timeLocation) {	  	
      return $http({
	  	method: 'get',        
        url: '/drugDrive/cf/Com/officerLocationService.cfc?method=getLocation&officerCollar='+collar+'&officerForce='+force+'&dateToFind='+dateLocation+'&timeToFind='+timeLocation
      });
    }
    return {
      getOfficerLocation: getOfficerLocation
    };
  }]);
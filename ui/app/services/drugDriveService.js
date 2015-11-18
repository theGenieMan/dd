angular.module('drugDrive')

  .factory('drugDriveService', ['$http', function($http) {

    var submitDD = function(form) {	  	
      return $http({
	  	method: 'post',        
        url: '../cf/Com/drugDriveWebService.cfc?method=createDrugDrive',
        data: form
      });
    };
	
	var getDD = function(ddId){
	 return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=getDrugDrive&DD_ID='+ddId
      });	
	}
	
	var finaliseDD = function(ddId){
	 return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveService.cfc?method=finaliseDrugDrive&DD_ID='+ddId
      });	
	}
	
	var locateOfficer = function(collar, force, dateLocation, timeLocation) {	
          
      var dateToFind = formatDate(dateLocation,'dd/MM/yyyy');
    	  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=getOfficerLocation&officerCollar='+collar+'&officerForce='+force+'&dateToFind='+dateToFind+'&timeToFind='+timeLocation
      });
    }
	
    return {
     submitDD: submitDD,
	 getDD: getDD,
	 finaliseDD: finaliseDD,
	 locateOfficer: locateOfficer
    };
  }]);
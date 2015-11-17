angular.module('drugDrive')

  .factory('drugDriveService', ['$http', function($http) {

    var submitDD = function(form) {	  	
      return $http({
	  	method: 'post',        
        url: '../cf/Com/drugDriveService.cfc?method=createDrugDrive',
        data: form
      });
    };
	
	var getDD = function(ddId){
	 return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveService.cfc?method=getDrugDriveJSON&DD_ID='+ddId
      });	
	}
	
	var finaliseDD = function(ddId){
	 return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveService.cfc?method=finaliseDrugDrive&DD_ID='+ddId
      });	
	}
	
    return {
     submitDD: submitDD,
	 getDD: getDD,
	 finaliseDD: finaliseDD
    };
  }]);
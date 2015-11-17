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
        url: '../cf/Com/drugDriveService.cfc?method=getDrugDrive&DD_ID='+ddId
      });	
	}
	
    return {
     submitDD: submitDD,
	 getDD: getDD
    };
  }]);
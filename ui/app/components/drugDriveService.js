angular.module('drugDrive')

  .factory('drugDriveService', ['$http', function($http) {

    var submitDD = function(form) {	  	
      return $http({
	  	method: 'post',        
        url: '../cf/Com/drugDriveService.cfc?method=createDrugDrive',
        data: form
      });
    }
    return {
     submitDD: submitDD
    };
  }]);
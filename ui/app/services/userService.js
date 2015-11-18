angular.module('drugDrive')
  .factory('userService', ['$http', function($http) {

    var getLoggedInUser = function() {	
                  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/userWebService.cfc?method=getUserDetailsJSON'
      });
    }
    return {
      getLoggedInUser: getLoggedInUser
    };
  }]);
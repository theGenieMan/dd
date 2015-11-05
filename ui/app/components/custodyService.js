app.factory('custodyService', ['$http', function($http) {

    var getCustodies = function() {	  	
      return $http({
	  	method: 'get',        
        url: '/drugDrive/cf/Com/custodyService.cfc?method=getCustodies'
      });
    }
    return {
      custodyList: getCustodies
    };
  }]);
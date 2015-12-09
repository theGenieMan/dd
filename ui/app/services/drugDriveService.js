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
        url: '../cf/Com/drugDriveWebService.cfc?method=finaliseDrugDrive&DD_ID='+ddId
      });	
	}
	
	var deleteDrugDrive = function(ddId){
	 return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=deleteDrugDrive&DD_ID='+ddId
      });	
	}
	
	var getUserDrugDrive = function(userId) {	  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=getUserDrugDrive&userId='+userId
      });
    }
	
	var getAdminDrugDrive = function() {	  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=getAdminDrugDrive'
      });
    }	
	
    var getAdminUserList = function() {	  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=getAdminUserList'
      });
    }	
	
    var addAdminUser = function(user) {	  	
      return $http({
	  	method: 'post',        
        url: '../cf/Com/drugDriveWebService.cfc?method=addAdminUser',
        data: user
      });
    };
	
	var deleteAdminUser = function(userId) {	  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=deleteAdminUser&userId='+userId
      });
    };
	
	var locateOfficer = function(collar, force, dateLocation, timeLocation) {	
          
      var dateToFind = formatDate(dateLocation,'dd/MM/yyyy');
    	  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=getOfficerLocation&officerCollar='+collar+'&officerForce='+force+'&dateToFind='+dateToFind+'&timeToFind='+timeLocation
      });
    }
	
	var getCustodies = function() {	  	
      return $http({
	  	method: 'get',        
        url: '../cf/Com/drugDriveWebService.cfc?method=getCustodies'
      });
    }
	
    return {
     submitDD: submitDD,
	 getDD: getDD,
	 finaliseDD: finaliseDD,
	 deleteDrugDrive: deleteDrugDrive,
	 getUserDrugDrive: getUserDrugDrive,
	 getAdminDrugDrive: getAdminDrugDrive,
	 getAdminUserList: getAdminUserList,
	 addAdminUser: addAdminUser,
	 deleteAdminUser: deleteAdminUser,
	 locateOfficer: locateOfficer,
	 getCustodies: getCustodies
    };
  }]);
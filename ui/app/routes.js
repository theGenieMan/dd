angular.module('drugDrive')
 .config(['$routeProvider', function($routeProvider){
 	
 	$routeProvider.when('/',
 		{
 			templateUrl: 'templates/pages/home/index.html',
 			controller: 'HomeController'
 		}
 	)
 	.when('/drugDriveForm',
 		{
 			templateUrl: 'templates/pages/drugDriveForm/index.html',
 			controller: 'DrugDriveController'	
 		}
 	)
	.when('/drugDriveForm/:ddId',
 		{
 			templateUrl: 'templates/pages/drugDriveForm/index.html',
 			controller: 'DrugDriveController'	
 		}
 	)
	.when('/userList',
 		{
 			templateUrl: 'templates/pages/userList/index.html'
 	})
 	
 }])
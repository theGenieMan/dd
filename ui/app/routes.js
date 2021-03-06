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
 			templateUrl: 'templates/pages/userList/index.html',
			controller: 'UserListController'
 	})
	.when('/submissionSuccess/:ddId',
 		{
 			templateUrl: 'templates/pages/submissionSuccess/index.html',
			controller: 'SubmissionSuccessController'
 	})
    .when('/admin',
 		{
 			templateUrl: 'templates/pages/admin/index.html',
			controller: 'AdminHomeController'
 	})
    .when('/adminList',
 		{
 			templateUrl: 'templates/pages/adminList/index.html',
			controller: 'AdminListController'
 	}) 	
    .when('/adminEditor',
 		{
 			templateUrl: 'templates/pages/adminEditor/index.html',
			controller: 'AdminEditorController'
 	}) 
    .when('/statsReport',
 		{
 			templateUrl: 'templates/pages/adminStats/index.html',
			controller: 'AdminStatsController'
 	}) 
   .when('/excelExport',
 		{
 			templateUrl: 'templates/pages/adminExcel/index.html',
			controller: 'AdminExcelController'
 	})
 	
 }])
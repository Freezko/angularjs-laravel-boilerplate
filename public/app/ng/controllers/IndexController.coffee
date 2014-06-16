"use strict"

define [config.appName], (app) ->
	app.register.controller "IndexController", [
		"$scope"
		"$http"
		($scope, $http) ->
			$scope.title = "AngularJS + Laravel Boilerplate"
	]
	return

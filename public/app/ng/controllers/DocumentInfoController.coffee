"use strict"

define [config.appName], (app) ->
	app.register.controller "DocumentInfoController", [
		"$scope"
		"$http"
		"$stateParams"
		($scope, $http, $stateParams) ->
			$scope.title = "Info " + "#{$stateParams.id}"
	]
	return

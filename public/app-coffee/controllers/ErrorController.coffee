"use strict'"
define ["app"], (app) ->
	app.register.controller "ErrorController", [
		"$scope"
		($scope) ->
			$scope.title = "Error"
	]
	return

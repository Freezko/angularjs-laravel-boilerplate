"use strict"
define [config.appName], (app) ->
	app.register.controller "RespectController", [
		"$scope"
		($scope) ->
			$scope.title = "Respect"
	]
	return

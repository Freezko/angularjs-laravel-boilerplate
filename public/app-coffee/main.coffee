require.config
	baseUrl: "/app"
	urlArgs: "bust=" + (new Date()).getTime()

require [
	"conf/config"
	"conf/routes"
	"app"
	"services/routeResolver"
], ->
	angular.bootstrap document, [config.appName]
	return

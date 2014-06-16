'use strict';

define [], ->
	services = angular.module('routeResolverServices', [])

	#Must be a provider since it will be injected into module.config()
	services.provider 'routeResolver', ->
		@$get = -> @

		@routeConfig = (->
			viewsDirectory = config.path.view
			controllersDirectory = config.path.controller

			setBaseDirectories = (viewsDir, controllersDir) ->
				viewsDirectory = viewsDir
				controllersDirectory = controllersDir


			getViewsDirectory = ->
				viewsDirectory


			getControllersDirectory = ->
				controllersDirectory

			return {
				setBaseDirectories: setBaseDirectories,
				getControllersDirectory: getControllersDirectory,
				getViewsDirectory: getViewsDirectory
			})()


		@route = ((routeConfig) ->
			resolve = (params) ->

				params.view = ""  unless params.view
				controllers = []

				routeDef = {}
				routeDef.url = params.url
				routeDef.templateUrl = routeConfig.getViewsDirectory() + params.view + config.ext.view if params.view unless ''
				routeDef.parent = params.parent if params.parent?
				routeDef.abstract = params.abstract if params.abstract?
				routeDef.data = params.data if params.data?

				if params.views?
					angular.forEach params.views, (stateparams, state) ->
						angular.forEach stateparams, (value, key) ->

							if key is 'view'
								params.views[state].templateUrl = routeConfig.getViewsDirectory() + value + config.ext.view
								delete params.views[state].view
							if key is 'controller'

								params.views[state].controller = value + config.controllerOutfix
								controllers.push routeConfig.getControllersDirectory() + value + config.controllerOutfix + config.ext.controller
					routeDef.views = params.views

				if params.controller?
					routeDef.controller = params.controller + config.controllerOutfix
					controllers.push routeConfig.getControllersDirectory() + routeDef.controller + config.ext.controller

				if params.controller? or controllers?
					routeDef.resolve =
						load: ['$q', '$rootScope', ($q, $rootScope) ->
							dependencies = controllers
							return resolveDependencies($q, $rootScope, dependencies)
						]

				routeDef


			resolveDependencies = ($q, $rootScope, dependencies) ->
				defer = $q.defer()
				require dependencies, ->
					defer.resolve()
					$rootScope.$apply()

				defer.promise



			resolve: resolve
			location: location

		)(@routeConfig)

		return
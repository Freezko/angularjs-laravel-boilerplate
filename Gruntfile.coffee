'use strict';
module.exports = (grunt)->

	# Load grunt tasks automatically
	require("load-grunt-tasks")(grunt)

	# Time how long tasks take. Can help when optimizing build times
	require('time-grunt')(grunt)

	config =
		bowerDir: 'public/assets/lib/js/vendor'
		libDir: 'public/assets/lib'
		assetsDir: 'public/assets'
		appDir: 'public/app'

	grunt.initConfig

		pkg: grunt.file.readJSON('package.json')

		#Directories
		config: config

		clean: ['<%= config.libDir %>/tmp']

		copy:
			requirejs:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/requirejs'
					src: ['require.js']
					dest: '<%= config.libDir %>/js'
				]

			jquery:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/jquery/dist'
					src: ['jquery.js']
					dest: '<%= config.libDir %>/js'
				]

			angular:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular'
					src: ['angular.js']
					dest: '<%= config.libDir %>/js/ng'
				]
			angularCookies:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-cookies'
					src: ['angular-cookies.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			ngcookies:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-cookies'
					src: ['angular-cookies.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			ngresource:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-resource'
					src: ['angular-resource.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			ngrouter:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-route'
					src: ['angular-route.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			nganimate:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-animate'
					src: ['angular-animate.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			ngsanitize:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-sanitize'
					src: ['angular-sanitize.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			ngstorage:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-storage/src'
					src: ['angularLocalStorage.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			uibootstrap:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-bootstrap'
					src: ['ui-bootstrap-tpls.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			uirouter:
				files: [
					expand: true
					cwd: '<%= config.bowerDir %>/angular-ui-router/release'
					src: ['angular-ui-router.js']
					dest: '<%= config.libDir %>/js/ng'
				]

			bootstrap:
				files: [
					{
						expand: true
						cwd: '<%= config.bowerDir %>/bootstrap/less'
						src: ['bootstrap.less']
						dest: '<%= config.libDir %>/tmp/bootstrap'
					}
					{
						expand: true
						cwd: '<%= config.bowerDir %>/bootstrap/dist/js'
						src: ['bootstrap.js']
						dest: '<%= config.libDir %>/js'
					}
					{
						expand: true
						cwd: '<%= config.bowerDir %>/bootstrap/dist/fonts'
						src: ['*']
						dest: '<%= config.libDir %>/fonts'
					}
				]

				iehtml5:
					files: [
						expand: true
						cwd: '<%= config.bowerDir %>/html5shiv/dist'
						src: ['*']
						dest: '<%= config.libDir %>/js'
					]

				iejson:
					files: [
						expand: true
						cwd: '<%= config.bowerDir %>/json3/lib'
						src: ['json3.js']
						dest: '<%= config.libDir %>/js'
					]


		concat:
			css:
				src: ['<%= config.libDir %>/tmp/bootstrap.css']
				dest: '<%= config.libDir %>/tmp/concat.css'
			js:
				src: [
					'<%= config.libDir %>/js/ng/angular.js'
					'<%= config.libDir %>/js/ng/*.js'
					'!<%= config.libDir %>/js/ng/ui-bootstrap-tpls.js'
					'<%= config.libDir %>/js/jquery.js'
					'<%= config.libDir %>/js/bootstrap.js'
				],
				dest: '<%= config.libDir %>/tmp/concat.js'


		less:
			bootstrap:
				options:
					ieCompat: true
					yuicompress: true
					paths: ['<%= config.libDir %>/less/bootstrap', '<%= config.libDir %>/tmp/bootstrap',
					        '<%= config.bowerDir %>/bootstrap/less', '<%= config.assetsDir %>/less']
				files:
					'<%= config.libDir %>/tmp/bootstrap.css': '<%= config.libDir %>/less/bootstrap/main.less'

	# Run some tasks in parallel to speed up the build process
		concurrent:
			dist: [
				'copy:styles'
				'imagemin'
				'bower'
			]

	# Allow the use of non-minsafe AngularJS files. Automatically makes it
	# minsafe compatible so Uglify does not destroy the ng references
		ngmin:
			dist:
				files: [
					expand: true
					cwd: '<%= config.libDir %>/js/ng'
					src: '*.js'
					dest: '<%= config.libDir %>/js/ng'
				]

		coffee:
			regular:
				expand: true
				flatten: false
				cwd: '<%= config.appDir %>-coffee'
				src: ['**/*.coffee']
				dest: '<%= config.appDir %>'
				ext: '.js'
				options:
					bare: true


		bower:
			install: true

		cssmin:
			css:
				options:
					keepSpecialComments: 0
				files:
					'<%= config.libDir %>/style.min.css': ['<%= config.libDir %>/tmp/concat.css']

		uglify:
			options:
				preserveComments: false
			my_target:
				files:
					'<%= config.libDir %>/script.min.js': ['<%= config.libDir %>/tmp/concat.js']
					'<%= config.libDir %>/require.min.js': ['<%= config.libDir %>/js/require.js']

		watch:
			less:
				files: ['<%= config.libDir %>/less/**/*.less', '<%= config.assetsDir %>/less']
				tasks: ['watching']
			coffee:
				files: ['<%= config.appDir %>-coffee/**/*.coffee']
				tasks: ['newer:coffee']
				options:
					livereload: true

		grunt.event.on 'watch', (action, filepath) ->
			# Delete compiled .js file of deleted source .coffee file.
			if action == 'deleted'
				filepath = filepath.replace "#{config.appDir}-coffee", ''
				jsFile = "#{config.appDir}" + filepath.replace /\.coffee$/, '.js'
				if grunt.file.exists jsFile
					grunt.file.delete jsFile
					grunt.log.ok 'File ' + jsFile + ' deleted'

	grunt.loadNpmTasks('grunt-contrib-less')
	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-githooks')
	grunt.loadNpmTasks('grunt-contrib-watch')
	grunt.loadNpmTasks('grunt-contrib-cssmin')
	grunt.loadNpmTasks('grunt-contrib-copy')
	grunt.loadNpmTasks('grunt-contrib-clean')
	grunt.loadNpmTasks('grunt-contrib-concat')
	grunt.loadNpmTasks('grunt-contrib-uglify')

	grunt.loadNpmTasks('grunt-bower-task')

	grunt.registerTask('default', ['bower', 'copy', 'less', 'concat', 'cssmin', 'uglify', 'coffee', 'clean'])
	grunt.registerTask('watching', ['less', 'concat', 'cssmin', 'clean'])

	grunt.registerTask('test', ['bower'])


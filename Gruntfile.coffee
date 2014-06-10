'use strict';
module.exports = (grunt)->

	# Load grunt tasks automatically
	#require("load-grunt-tasks")(grunt)

	# Time how long tasks take. Can help when optimizing build times
	require('time-grunt')(grunt)

	#read env from .htaccess
	env = grunt.file.read('public/.htaccess').match(/setEnv\sAPP_ENV\s(.*)\s/im)[1];

	if env not in ['production', 'local']
		grunt.log.error('env is bad');
		return;

	config =
		bowerDir: 'public/assets/lib/js/vendor'
		libDir: 'public/assets/lib'
		assetsDir: 'public/assets'
		appDir: 'public/app'

	grunt.initConfig

		#pkg: grunt.file.readJSON('package.json')

		#Directories
		config: config

		clean: ['<%= config.libDir %>/tmp', '.tmp']

		bowercopy:
			js:
				options:
					destPrefix:
						'<%= config.libDir %>/js'
				files:
					'jquery.js' 			: 'jquery/dist/jquery.js'
					'require.js' 			: 'requirejs/require.js'
					'json3.js' 				: 'json3/lib/json3.js'
					'html5shiv-printshiv.js': 'html5shiv/dist/html5shiv-printshiv.js'
			ng:
				options:
					destPrefix:
						'<%= config.libDir %>/js/ng'
				files:
					'angular.js' 			: 'angular/angular.js'
					'angular-animate.js' 	: 'angular-animate/angular-animate.js'
					'angular-cookies.js' 	: 'angular-cookies/angular-cookies.js'
					'angular-resource.js' 	: 'angular-resource/angular-resource.js'
					'angular-route.js' 		: 'angular-route/angular-route.js'
					'angular-sanitize.js' 	: 'angular-sanitize/angular-sanitize.js'
					'angular-ui-router.js' 	: 'angular-ui-router/release/angular-ui-router.js'
					'angularLocalStorage.js': 'angularLocalStorage/src/angularLocalStorage.js'
			bootstrap:
				files:
					'<%= config.libDir %>/js/bootstrap.js' : 'bootstrap/dist/js/bootstrap.js'
					'<%= config.libDir %>/fonts' : 'bootstrap/dist/fonts/*'
					'<%= config.libDir %>/css/bootstrap.css' : 'bootstrap/dist/css/bootstrap.css'


		less:
			compile:
				options:
					ieCompat: true
					yuicompress: true
			files:
				expand: true,
				cwd: '<%= config.assetsDir %>/less'
				src: '**/*.less'
				dest: '<%= config.assetsDir %>/css'
				ext: '.less.css'

#		concat:
#			css:
#				src: [
#					'!<%= config.assetsDir %>/css/*.less.css'
#					'<%= config.assetsDir %>/css/main.less.css'
#					'<%= config.libDir %>/css/bootstrap.css'
#					'<%= config.assetsDir %>/css/*.css'
#
#				]
#				dest: '<%= config.libDir %>/tmp/concat.css'
#			js:
#				src: [
#					'<%= config.libDir %>/js/json3.js'
#					'<%= config.libDir %>/js/html5shiv-printshiv.js'
#					'<%= config.libDir %>/js/ng/angular.js'
#					'<%= config.libDir %>/js/ng/*.js'
#					'<%= config.libDir %>/js/jquery.js'
#					'<%= config.libDir %>/js/bootstrap.js'
#				],
#				dest: '<%= config.libDir %>/tmp/concat.js'


		cssmin:
			css:
				options:
					keepSpecialComments: 0
				files:
					'<%= config.libDir %>/style.min.css': ['<%= config.libDir %>/tmp/concat.css']

#		uglify:
#			options:
#				preserveComments: false
#			my_target:
#				files:
#					'<%= config.libDir %>/script.min.js': ['<%= config.libDir %>/tmp/concat.js']
#					'<%= config.libDir %>/require.min.js': ['<%= config.libDir %>/js/require.js']

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

		phpunit:
			classes:
				dir: 'app/tests/'
			options:
				bin: 'vendor/bin/phpunit'
				colors: false


		useminPrepare:
			html: ['app/views/layouts/{,*/}*.php']

			options:
				dest: 'public/assets/lib/'
				root: 'public/'
				flow:
					html:
						steps:
							js: ['concat', 'uglifyjs']
						post: {}

		copy:
			dist:
				files: [
					expand: true
					dot: true
					cwd: 'app/views/layouts'
					dest: 'app/views-dist/layouts'
					src: ['{,*/}*.php']
				]

		usemin:
			html: ['app/views-dist/layouts/{,*/}*.php']

		watch:
			less:
				files: ['<%= config.assetsDir %>/less/**/*.less', '<%= config.assetsDir %>/css/**/*.css']
				tasks: ['css']
			coffee:
				files: ['<%= config.appDir %>-coffee/**/*.coffee']
				tasks: ['newer:coffee']
			tests:
			#files: ['app/controllers/*.php','app/models/*.php', 'app/tests/*.php', 'app/view/*php']
				files: ['app/**/*.php']
				tasks: ['phpunit']

	# Run some tasks in parallel to speed up the build process
	#	concurrent:
	#		dist: [
	#			'copy:styles'
	#			'imagemin'
	#			'bower'
	#		]

	# Allow the use of non-minsafe AngularJS files. Automatically makes it
	# minsafe compatible so Uglify does not destroy the ng references
	#	ngmin:
	#		dist:
	#			files: [
	#				expand: true
	#				cwd: '<%= config.libDir %>/js/ng'
	#				src: '*.js'
	#				dest: '<%= config.libDir %>/js/ng'
	#			]


		grunt.event.on 'watch', (action, filepath) ->
			# Delete compiled .js file of deleted source .coffee file.
			if action == 'deleted'
				filepath = filepath.replace "#{config.appDir}-coffee", ''
				jsFile = "#{config.appDir}" + filepath.replace /\.coffee$/, '.js'
				if grunt.file.exists jsFile
					grunt.file.delete jsFile
					grunt.log.ok 'File ' + jsFile + ' deleted'

	grunt.loadNpmTasks('grunt-contrib-less') #less
	grunt.loadNpmTasks('grunt-contrib-coffee') #coffee
	grunt.loadNpmTasks('grunt-contrib-copy') #copy
	#grunt.loadNpmTasks('grunt-githooks')
	grunt.loadNpmTasks('grunt-contrib-watch') #watch
	grunt.loadNpmTasks('grunt-contrib-cssmin') #css-mi
	grunt.loadNpmTasks('grunt-contrib-clean') #clean
	grunt.loadNpmTasks('grunt-contrib-concat') 	#concat
	grunt.loadNpmTasks('grunt-contrib-uglify') #js-min
	grunt.loadNpmTasks('grunt-phpunit'); #phpunit
	#grunt.loadNpmTasks('grunt-bower-task') #bower
	grunt.loadNpmTasks('grunt-newer'); #newer files
	grunt.loadNpmTasks('grunt-bowercopy');
	grunt.loadNpmTasks('grunt-usemin');

	grunt.registerTask('default', ['bowercopy', 'less', 'concat', 'cssmin', 'uglify', 'coffee', 'clean'])
	grunt.registerTask('css', ['less', 'concat', 'cssmin', 'clean'])
	grunt.registerTask('test', ['useminPrepare','concat',  'uglify','copy:dist', 'usemin'])




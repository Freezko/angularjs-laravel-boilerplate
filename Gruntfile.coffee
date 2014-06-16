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
		base				: 'public'
		bower				: 'public/bower'
		lib					: 'public/lib'

		app:
			base			: 'public/app'
			assets			: 'public/app/assets'
			ng				: 'public/app/ng'

		dist:
			base			: 'public/dist'
			assets			: 'public/dist/assets'
			ng				: 'public/dist/ng'

		php:
			layouts 		: 'app/views/layouts'
			layoutsDist		: 'app/views-dist/layouts'


	grunt.initConfig

		#pkg: grunt.file.readJSON('package.json')

		#Directories
		config: config

		clean: [
				'<%= config.app.base %>/.tmp'
				'.tmp'
				'<%= config.dist.base %>'
				'<%= config.lib %>'
				'<%= config.php.layoutsDist %>'
				]
		#инсталируем библиотеки и копируем в папку main файлы
		bowercopy:
			js:
				options:
					destPrefix:
						'<%= config.base %>/lib/js'
				files:
					'jquery.js' 			: 'jquery/dist/jquery.js'
					'require.js' 			: 'requirejs/require.js'
					'json3.js' 				: 'json3/lib/json3.js'
					'html5shiv-printshiv.js': 'html5shiv/dist/html5shiv-printshiv.js'
			ng:
				options:
					destPrefix:
						'<%= config.base %>/lib/js/ng'
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
				options:
					destPrefix:
						'<%= config.base %>/lib/'
				files:
					'js/bootstrap.js' : 'bootstrap/dist/js/bootstrap.js'
					'fonts' : 'bootstrap/dist/fonts/*'
					'css/bootstrap.css' : 'bootstrap/dist/css/bootstrap.css'

		#компилируем less
		less:
			compile:
				options:
					ieCompat: true
					yuicompress: true
			files:
				expand: true,
				cwd: '<%= config.app.assets %>/less'
				src: '**/*.less'
				dest: '<%= config.dist.assets %>/less'
				ext: '.less.css'

		#компилируем coffee
		coffee:
			regular:
				expand: true
				flatten: false
				cwd: '<%= config.app.ng %>'
				src: ['**/*.coffee']
				dest: '<%= config.dist.ng %>'
				ext: '.js'
				options:
					bare: true


		#copy all layouts  to dist folder and JS CSS files
		copy:
			dist:
				files: [
					{
						expand: true
						dot: true
						cwd: '<%= config.php.layouts %>'
						dest: '<%= config.php.layoutsDist %>'
						src: ['{,*/}*.php']
					}
					{
						expand: true
						dot: true
						cwd: '<%= config.app.assets %>/css'
						dest: '<%= config.dist.assets %>/css'
						src: ['{,*/}*']
					}
					{
						expand: true
						dot: true
						cwd: '<%= config.app.assets %>/js'
						dest: '<%= config.dist.assets %>/js'
						src: ['{,*/}*']
					}
				]

		#подготавливаем файлы для конкатинации и минификации прописанные в layouts
		useminPrepare:
			html: ['<%= config.php.layouts %>/{,*/}*.php']

			options:
				dest: 'public/'
				root: 'public/'
				flow:
					html:
						steps:
							js: ['concat', 'uglifyjs']
							css: ['concat', 'cssmin']
						post: {}

		#минифицируем сами require.js
		uglify:
			options:
				preserveComments: false
			require:
				files:
					'<%= config.lib %>/js/require.min.js': ['<%= config.lib %>/js/require.js']


		# Renames files for browser caching purposes
		rev:
			dist:
				files:
					src: ['lib/**/*.min.{js,css}']

		#convert dist layouts
		usemin:
			html: ['app/views-dist/layouts/{,*/}*.php']
			options:
				assetsDirs: ['public/']


		phpunit:
			classes:
				dir: 'app/tests/'
			options:
				bin: 'vendor/bin/phpunit'
				colors: false


		watch:
			less:
				files: ['<%= config.app.assets %>/less/**/*.less']
				tasks: ['newer:less']
			copydist:
				files: ['<%= config.app.assets %>/css/**/*.css', '<%= config.app.assets %>/js/**/*.js']
				tasks: ['newer:copy']
			layouts:
				files: ['<%= config.php.layouts %>/**/*.php']
				tasks: ['newer:copy']
			coffee:
				files: ['<%= config.app.ng %>/**/*.coffee']
				tasks: ['newer:coffee']
			tests:
			#files: ['app/controllers/*.php','app/models/*.php', 'app/tests/*.php', 'app/view/*php']
				files: ['app/**/*.php']
				tasks: ['phpunit']

		 #Run some tasks in parallel to speed up the build process
#		concurrent:
#			dist: [
#				'bowercopy'
#				'less'
#				'coffee'
#				'copy'
#			]


		grunt.event.on 'watch', (action, filepath) ->
			# Delete compiled .js file of deleted source .coffee file.
			if action == 'deleted'
				File = filepath.replace "#{config.app.base}", "#{config.dist.base}"
				File = File.replace /\.coffee$/, '.js'
				File = File.replace /\.less$/, '.less.css'
				if grunt.file.exists File
					grunt.file.delete File
					grunt.log.ok 'File ' + File + ' deleted'

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
	#grunt.loadNpmTasks('grunt-concurrent');
	grunt.loadNpmTasks('grunt-newer'); #newer files
	grunt.loadNpmTasks('grunt-bowercopy');
	grunt.loadNpmTasks('grunt-usemin');
	grunt.loadNpmTasks('grunt-rev');


	grunt.registerTask('production', ['clean','bowercopy', 'less', 'coffee', 'copy', 'useminPrepare', 'concat', 'uglify', 'cssmin','rev', 'usemin'])
	grunt.registerTask('dev', ['clean','bowercopy', 'less', 'coffee', 'copy',  'uglify'])

	grunt.registerTask('default', ['production'])




<!doctype html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<title>AngularJS + Laravel Boilerplate</title>
	<link rel="stylesheet" type="text/css" href="/assets/lib/style.min.css" />
</head>
<body>

	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav">
				<li>
					<a href="/">HOME</a>
				</li>
				<li>
					<a ui-sref="respect">RESPECT</a>
				</li>
				<li>
					<a href="/other">error page</a>
				</li>
				<li>
					<a href="/document/45">document</a>
				</li>
			</ul>
		</div>
	</div>

	<div class="container" ui-view></div>
	<div class="container" ui-view="info"></div>
	<!--[if lt IE 9]>
	<script src="assets/lib/js/html5shiv.js"></script>
	<script src="assets/lib/json3.js"></script>
	<![endif]-->

	<!-- build:js /assets/lib/script.min.js -->
	<script type="text/javascript" src="/assets/lib/js/ng/angular.js"></script>
	<script type="text/javascript" src="/assets/lib/js/ng/angular-animate.js"></script>
	<script type="text/javascript" src="/assets/lib/js/ng/angular-cookies.js"></script>
	<script type="text/javascript" src="/assets/lib/js/ng/angularLocalStorage.js"></script>
	<script type="text/javascript" src="/assets/lib/js/ng/angular-resource.js"></script>
	<script type="text/javascript" src="/assets/lib/js/ng/angular-route.js"></script>
	<script type="text/javascript" src="/assets/lib/js/ng/angular-sanitize.js"></script>
	<script type="text/javascript" src="/assets/lib/js/ng/angular-ui-router.js"></script>
	<script type="text/javascript" src="/assets/lib/js/jquery.js"></script>
	<script type="text/javascript" src="/assets/lib/js/bootstrap.js"></script>
	<!-- endbuild -->

	<script type="text/javascript" src="/assets/lib/require.min.js" data-main="/app/main"></script>
</body>
</html>

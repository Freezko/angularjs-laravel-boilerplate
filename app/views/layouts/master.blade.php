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
	<script src="assets/js/html5shiv.js"></script>
	<script src="assets/js/json3.js"></script>
	<![endif]-->

	<script type="text/javascript" src="/assets/lib/script.min.js"></script>
	<script type="text/javascript" src="/assets/lib/require.min.js" data-main="/app/main"></script>
</body>
</html>

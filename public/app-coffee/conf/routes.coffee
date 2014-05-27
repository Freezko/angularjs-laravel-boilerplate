routes =
	"index":
		url: "/"
		controller: "Index"
		view: "index"

	"document":
		url: "/document/:id"
		views:
			"" :
				controller: "Document"
				view: "document"
			"info" :
				controller: "DocumentInfo"
				view: "document.info"

	"respect":
		url: "/respect"
		controller: "Respect"
		view: "respect"

	"error":
		url: "/error"
		controller: "Error"
		error: "404"
		view: "404"

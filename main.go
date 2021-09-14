package main

import (
	"embed"
	"io/fs"
	"net/http"

	inertia "github.com/petaki/inertia-go"
)

var url = "http://inertia-app.test"    // Application URL for redirect
var rootTemplate = "template/app.html" // Root template, see the example below
var version = ""

//go:embed template
var templateFS embed.FS
//go:embed build/_ build/_snowpack
var staticFS embed.FS
                      // Asset version

var inertiaManager = inertia.NewWithFS(url, rootTemplate, version, templateFS)

func main() {
	mux := http.NewServeMux()
	staticFs, err := fs.Sub(staticFS, "build")

	if err != nil {
		panic(err)
	}

	// Static javascript & css assets are saved to these routes
	mux.Handle("/_/", http.FileServer(http.FS(staticFs)))
	mux.Handle("/_snowpack/", http.FileServer(http.FS(staticFs)))


	mux.Handle("/", inertiaManager.Middleware(http.HandlerFunc(homeHandler)))
	mux.Handle("/team", inertiaManager.Middleware(http.HandlerFunc(teamHandler)))

	if err := http.ListenAndServe(":8081", mux); err != nil {
		panic(err)
	}
}

func homeHandler(w http.ResponseWriter, r *http.Request) {
	err := inertiaManager.Render(w, r, "Index", nil)
	if err != nil {
		panic(err)
	}
}

func teamHandler(w http.ResponseWriter, r *http.Request) {
	err := inertiaManager.Render(w, r, "Team", nil)
	if err != nil {
		panic(err)
	}
}
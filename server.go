package main

import (
	"flag"
	"net/http"
	"os/exec"
)

func main() {
	var port string
	flag.StringVar(&port, "port", "8080", "Port to run the server on")
	flag.Parse()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain; charset=utf-8")
		output, err := exec.Command("./cobol-age").Output()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.Write(output)
	})
	http.ListenAndServe(":"+port, nil)
}
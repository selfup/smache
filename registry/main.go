package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func httpHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "orchastration registry")
}

func definePort() string {
	portEnv := os.Getenv("PORT")

	if portEnv != "" {
		return ":" + portEnv
	}

	return ":8081"
}

func main() {
	http.HandleFunc("/", httpHandler)
	log.Fatal(http.ListenAndServe(definePort(), nil))
}

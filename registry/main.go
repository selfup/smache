package main

import (
	"fmt"
	"log"
	"net/http"
	"sync"
)

var (
	mutex  = &sync.Mutex{}
	client *http.Client
)

func httpHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "orchastration registry")
}

func main() {
	http.HandleFunc("/", httpHandler)
	log.Fatal(http.ListenAndServe(":4001", nil))
}

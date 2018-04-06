package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"sync"
)

var (
	mutex = &sync.Mutex{}
	count = 0
	ips   = [2]string{"0.0.0.0:1234", "0.0.0.0:1235"}
)

func hello(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")

	mutex.Lock()
	uri := fmt.Sprintf("http://%s%s", ips[0], "/api/?key=1")

	if count == 1 {
		count--
	} else {
		count++
	}
	mutex.Unlock()

	res, err := http.Get(uri)

	if err != nil {
		fmt.Fprintf(w, "call to node failed")
	}

	io.Copy(w, res.Body)
}

func main() {
	http.HandleFunc("/", hello)

	err := http.ListenAndServe(":8081", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

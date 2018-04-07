package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"sync"
	"time"
)

var (
	mutex   = &sync.Mutex{}
	count   = 0
	client  *http.Client
	dockers = [2]string{"172.17.0.1:1234", "172.17.0.1:1235"}
	ips     = [2]string{"192.168.1.7:1234", "192.168.1.7:1235"}
)

func httpHandler(w http.ResponseWriter, r *http.Request) {
	mutex.Lock()
	uri := fmt.Sprintf("http://%s%s", ips[count], "/api/?key=1")

	if count == 1 {
		count--
	} else {
		count++
	}
	mutex.Unlock()

	res, err := client.Get(uri)

	if err != nil {
		failedURI := fmt.Sprintf("call to %s failed", uri)

		fmt.Fprintf(w, failedURI)
	}

	io.Copy(w, res.Body)

	defer res.Body.Close()
}

func main() {
	transport := &http.Transport{
		MaxIdleConnsPerHost: 1024,
		TLSHandshakeTimeout: 0 * time.Second,
	}

	client = &http.Client{Transport: transport}

	http.HandleFunc("/", httpHandler)
	log.Fatal(http.ListenAndServe(":8081", nil))
}

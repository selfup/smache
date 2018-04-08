package main

import (
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"sync"
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

	defer res.Body.Close()

	io.Copy(w, res.Body)
}

func findMachineIP() string {
	addrs, err := net.InterfaceAddrs()

	if err != nil {
		return ""
	}

	for _, addr := range addrs {
		networkIP, ok := addr.(*net.IPNet)
		if ok && !networkIP.IP.IsLoopback() && networkIP.IP.To4() != nil {
			return networkIP.IP.String()
		}
	}

	return ""
}

func main() {
	transport := &http.Transport{
		MaxIdleConns:        1000,
		MaxIdleConnsPerHost: 1000,
	}

	client = &http.Client{Transport: transport}

	fmt.Println(findMachineIP())

	http.HandleFunc("/", httpHandler)
	log.Fatal(http.ListenAndServe(":8081", nil))
}

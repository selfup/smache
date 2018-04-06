package main

import (
	"fmt"
	"sync"

	"github.com/valyala/fasthttp"
)

var (
	mutex = &sync.Mutex{}
	count = 0
	ips   = [2]string{"172.17.0.1:1234", "172.17.0.1:1235"}
)

func fastHTTPHandler(ctx *fasthttp.RequestCtx) {
	mutex.Lock()
	uri := fmt.Sprintf("http://%s%s", ips[count], "/api/?key=1")

	if count == 1 {
		count--
	} else {
		count++
	}
	mutex.Unlock()

	_, body, err := fasthttp.Get(nil, uri)

	fmt.Println(body)

	if err != nil {
		fmt.Fprintf(ctx, "call to node failed")
	}

	ctx.Write(body)
}

func main() {
	fasthttp.ListenAndServe(":8081", fastHTTPHandler)
}

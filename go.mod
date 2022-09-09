module github.com/defval/go-dota2

go 1.17

// note: protobuf is intentionally held at 1.3.x
//replace github.com/golang/protobuf => github.com/golang/protobuf v1.3.5

require (
	github.com/Philipp15b/go-steam/v3 v3.0.0
	github.com/defval/go-steam/v3 v3.0.0-20220909232631-ef9c66fcf9a4
	github.com/fatih/camelcase v1.0.0
	github.com/golang/protobuf v1.5.0
	github.com/pkg/errors v0.8.1
	github.com/serenize/snaker v0.0.0-20171204205717-a683aaf2d516
	github.com/sirupsen/logrus v1.4.2
	github.com/urfave/cli v1.21.0
	google.golang.org/protobuf v1.28.0
)

require (
	github.com/konsorten/go-windows-terminal-sequences v1.0.1 // indirect
	github.com/onsi/ginkgo v1.9.0 // indirect
	github.com/onsi/gomega v1.6.0 // indirect
	golang.org/x/net v0.0.0-20190311183353-d8887717615a // indirect
	golang.org/x/sys v0.0.0-20190422165155-953cdadca894 // indirect
)

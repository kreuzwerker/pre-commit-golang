
# pre-commit-golang

golang hooks for http://pre-commit.com/

## Using these hooks

Add this to your `.pre-commit-config.yaml`

    - repo: git://github.com/kreuzwerker/pre-commit-golang
      rev: master
      hooks:
        - id: no-go-testing
        - id: golangci-lint
        - id: go-unit-tests
        - id: go-build
        - id: go-mod-tidy

## Available hooks

- `no-go-testing` - Checks that no files are using `testing.T`, if you want
  developers to use a different testing framework
- `golangci-lint` - run `golangci-lint run ./...`, requires
  [golangci-lint](https://github.com/golangci/golangci-lint)
- `go-unit-tests` - run `go test -tags=unit -timeout 30s -short -v`
- `go-build` - run `go build`, requires golang
- `go-mod-tidy` - run `go mod tidy -v`, requires golang
- `go-mod-vendor` - run `go mod vendor`, requires golang

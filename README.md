
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/kreuzwerker/pre-commit-golang/master.svg)](https://results.pre-commit.ci/latest/github/kreuzwerker/pre-commit-golang/master)


# pre-commit-golang

golang hooks for http://pre-commit.com/, golang `1.11+` and `go.mod` only

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
  [golangci-lint](https://github.com/golangci/golangci-lint) installed and executable in the `bin` directory of the project
- `go-unit-tests` - run `go test -tags=unit -timeout 30s -short -v`
- `go-build` - run `go build`, requires golang
- `go-mod-tidy` - run `go mod tidy -v`, requires golang
- `go-mod-vendor` - run `go mod vendor`, requires golang

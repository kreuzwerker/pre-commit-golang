# A Self-Documenting Makefile: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html

OS = $(shell uname | tr A-Z a-z)
export PATH := $(abspath bin/):${PATH}

VERSION = $(shell git describe --abbrev=7 --always | cut -d"-" -f 1,3 | sed -e 's/^v//g' || echo ${CI_COMMIT_REF_SLUG} )
GITCHGLOG_VERSION = 0.14.2

.PHONY: setup
setup:
	rm -f .git/hooks/commit-msg \
	&& curl --fail -o .git/hooks/commit-msg https://raw.githubusercontent.com/hazcod/semantic-commit-hook/master/commit-msg \
	&& chmod 500 .git/hooks/commit-msg


.PHONY: clear
clear: ## Clear the working area and the project
	rm -rf bin

bin/git-chglog: bin/git-chglog-${GITCHGLOG_VERSION}
	@ln -sf git-chglog-${GITCHGLOG_VERSION} bin/git-chglog
bin/git-chglog-${GITCHGLOG_VERSION}:
	@mkdir -p bin
	curl -L https://github.com/git-chglog/git-chglog/releases/download/v${GITCHGLOG_VERSION}/git-chglog_${GITCHGLOG_VERSION}_${OS}_amd64.tar.gz | tar -zOxf - git-chglog > ./bin/git-chglog-${GITCHGLOG_VERSION} && chmod +x ./bin/git-chglog-${GITCHGLOG_VERSION}

release-%: TAG_PREFIX = "v"
release-%: bin/git-chglog
	@echo "Generating CHANGELOG"
	bin/git-chglog --next-tag $* -o CHANGELOG.md
ifeq (${TAG}, 1)
	@echo "Committing and tagging"
	git add CHANGELOG.md
	git commit -m 'chore: prepare release $*'
	git tag -m 'Release $*' ${TAG_PREFIX}$*
ifeq (${PUSH}, 1)
	git push; git push origin ${TAG_PREFIX}$*
endif
endif

	@echo "Version updated to $*!"
ifneq (${PUSH}, 1)
	@echo
	@echo "Review the changes made by this script then execute the following:"
ifneq (${TAG}, 1)
	@echo
	@echo "git add CHANGELOG.md && git commit -m 'chore: prepare release $*' && git tag -m 'Release $*' ${TAG_PREFIX}$*"
	@echo
	@echo "Finally, push the changes:"
endif
	@echo
	@echo "git push; git push origin ${TAG_PREFIX}$*"
endif

.PHONY: patch
patch: ## Release a new patch version
	@${MAKE} release-$(shell (git describe --abbrev=0 --tags 2> /dev/null || echo "0.0.0") | sed 's/^v//' | awk -F'[ .]' '{print $$1"."$$2"."$$3+1}')

.PHONY: minor
minor: ## Release a new minor version
	@${MAKE} release-$(shell (git describe --abbrev=0 --tags 2> /dev/null || echo "0.0.0") | sed 's/^v//' | awk -F'[ .]' '{print $$1"."$$2+1".0"}')

.PHONY: major
major: ## Release a new major version
	@${MAKE} release-$(shell (git describe --abbrev=0 --tags 2> /dev/null || echo "0.0.0") | sed 's/^v//' | awk -F'[ .]' '{print $$1+1".0.0"}')

.PHONY: list
list: ## List all make targets
	@${MAKE} -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

.PHONY: help
.DEFAULT_GOAL := help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Variable outputting/exporting rules
var-%: ; @echo $($*)
varexport-%: ; @echo $*=$($*)

### Variables
DAGU_VERSION=1.12.11
POST_CLI_VERSION=0.12.5

pkg-dagu:
	@echo "Cleaning ./dagu dir except ./dagu/dags dir"
	@cd dagu && \
	find . ! -path '*/dags/*' ! -path './dags' ! -path '.' -exec rm -rf {} \;

	@echo "Downloading dagu: https://github.com/dagu-dev/dagu/releases/download/v$(DAGU_VERSION)/dagu_$(DAGU_VERSION)_linux_amd64.tar.gz"
	@cd dagu && \
	curl -LO https://github.com/dagu-dev/dagu/releases/download/v$(DAGU_VERSION)/dagu_$(DAGU_VERSION)_linux_amd64.tar.gz && \
	tar -xvf dagu_$(DAGU_VERSION)_linux_amd64.tar.gz && \
	rm dagu_$(DAGU_VERSION)_linux_amd64.tar.gz
.PHONY: pkg-dagu

pkg-post-cli:
	@echo "Cleaning ./postcli"
	@rm -rf postcli && mkdir postcli

	@echo "Downloading postcli: https://github.com/spacemeshos/post/releases/download/v$(POST_CLI_VERSION)/postcli-macOS_ARM64.zip"
	@cd postcli && \
	curl -LO https://github.com/spacemeshos/post/releases/download/v$(POST_CLI_VERSION)/postcli-macOS_ARM64.zip && \
	unzip postcli-macOS_ARM64.zip && \
	rm postcli-macOS_ARM64.zip
.PHONY: pkg-post-cli

cfg-spacemesh:
	@cp -r ./example/go-spacemesh/* ./go-spacemesh/
.PHONY: cfg-spacemesh
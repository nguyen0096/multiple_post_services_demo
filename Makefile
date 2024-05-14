### Variables
DAGU_VERSION=1.12.11
POST_CLI_VERSION=0.12.5
DAGU_PKG=dagu_$(DAGU_VERSION)_darwin_arm64.tar.gz
POST_CLI_PKG=postcli-macOS_ARM64.zip

pkg-dagu:
	@echo "Cleaning ./dagu dir except ./dagu/dags dir"
	@cd dagu && \
	find . ! -path '*/dags/*' ! -path './dags' ! -path '.' -exec rm -rf {} \;

	@echo "Downloading dagu: https://github.com/dagu-dev/dagu/releases/download/v$(DAGU_VERSION)/$(DAGU_PKG)"
	@cd dagu && \
	curl -LO https://github.com/dagu-dev/dagu/releases/download/v$(DAGU_VERSION)/$(DAGU_PKG) && \
	tar -xvf $(DAGU_PKG) && rm $(DAGU_PKG) && \
	chmod +x ./dagu
.PHONY: pkg-dagu

pkg-postcli:
	@echo "Cleaning ./postcli"
	@rm -rf postcli && mkdir postcli

	@echo "Downloading postcli: https://github.com/spacemeshos/post/releases/download/v$(POST_CLI_VERSION)/$(POST_CLI_PKG)"
	@cd postcli && \
	curl -LO https://github.com/spacemeshos/post/releases/download/v$(POST_CLI_VERSION)/$(POST_CLI_PKG) && \
	unzip $(POST_CLI_PKG) && rm $(POST_CLI_PKG) && \
	chmod +x ./postcli
.PHONY: pkg-post-cli


# Commands: demo
# Example: make demo-spacemesh GENESIS_TIME=2024-03-08T14:30:00Z07:00
demo-run-dagu:
	@echo "Starting Dagu"
	@cd ./dagu && ./dagu server -d dags
.PHONY: demo-run-dagu

demo-run-build:
	@echo "Starting Spacemesh"
	@cd ./go-spacemesh && ./build/go-spacemesh -c config.json --preset=standalone --genesis-time=$(GENESIS_TIME) --grpc-json-listener 127.0.0.1:10095 -d ./node_data | tee -a node.log
.PHONY: demo-run-build

demo-config:
	@cp -r ./example/go-spacemesh/* ./go-spacemesh
.PHONY: demo-config

demo-clean:
	@sudo rm -rf ./go-spacemesh/node_data
	@sudo rm -rf ./post
.PHONY: demo-clean
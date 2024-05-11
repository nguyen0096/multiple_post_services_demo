### Variables
DAGU_VERSION=1.12.11

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

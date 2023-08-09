default: build

build:
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@echo "Running static analysis"
	@../hadolint --ignore DL3018 Dockerfile
	@docker images lp/hugo-builder
	@docker run -it -p 1313:1313 lp/hugo-builder 

.PHONY: build

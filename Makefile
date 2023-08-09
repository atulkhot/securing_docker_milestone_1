default: build

build:
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@docker images lp/hugo-builder
	@docker run -it --mount type=bind,source="${PWD}"/orgdocs,target=/src/orgdocs  -p 1313:1313 lp/hugo-builder sh -c "cd orgdocs; hugo server -w --bind=0.0.0.0"

.PHONY: build

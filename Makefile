SATYSFI_IMAGE:=shinchoku-tairiku-builder
PDFTOOLS_IMAGE:=shinchoku-tairiku-pdftools

BOOK_NAME:=book-template-artifact.pdf
BOOK_TITLE:=book-template
BOOK_AUTHORS:=@author1

.PHONY: all
all: build-content-docker combine-docker

.PHONY: build-content-docker
build-content-docker:
	docker run --rm -it --mount type=bind,source="$(shell pwd)",target=/workspace "$(SATYSFI_IMAGE)" make build-content

.PHONY: combine-docker
combine-docker:
	docker run --rm -it --mount type=bind,source="$(shell pwd)",target=/workspace "$(PDFTOOLS_IMAGE)" make combine

.PHONY: shell-docker
shell-docker:
	docker run --rm -it --mount type=bind,source="$(shell pwd)",target=/workspace "$(SATYSFI_IMAGE)" /bin/bash

###

.PHONY: build-content
build-content:
	satysfi src/main.saty -o output/content.pdf

.PHONY: check-content
check-content:
	satysfi --debug-show-overfull src/main.saty -o output/check.pdf

.PHONY: combine
combine:
	pdftk A=assets/cover.pdf B=output/content.pdf cat A B output "output/$(BOOK_NAME)"
	exiftool -Title='$(BOOK_TITLE)' -Author='$(BOOK_AUTHORS)' -Producer='SATySFi' -Creator='SATySFi' -overwrite_original "output/$(BOOK_NAME)"

###

.PHONY: docker
docker: docker-build-builder docker-build-pdftools

.PHONY: docker-build-builder
docker-build-builder:
	docker build -t shinchoku-tairiku-builder -f dockerfiles/Dockerfile.builder .

.PHONY: docker-build-pdftools
docker-build-pdftools:
	docker build -t shinchoku-tairiku-pdftools:latest -f dockerfiles/Dockerfile.pdftools .

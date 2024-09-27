.DEFAULT_GOAL := build

#model := Llama-3.2-1B-Instruct-Q4_K_M
model := Llama-3.2-1B-Instruct-Q5_K_M
#model := Llama-3.2-1B-Instruct-Q8_0
#model := Llama-3.2-3B-Instruct-Q4_K_M
#model := Llama-3.2-3B-Instruct-Q5_K_M
#model := Llama-3.2-3B-Instruct-Q8_0
#model := Meta-Llama-3.1-8B-Instruct-Q5_K_M
#model := Meta-Llama-3.1-70B-Instruct-Q5_K_M

llamafile_version := 0.8.13

.PHONY: build
build: llamafile/bin/llamafile clean
	mkdir -p build
	cp llamafile/bin/llamafile build/$(model).llamafile
	echo "-m\n$(model).gguf\n-c\n0\n..." >build/.args
	./llamafile/bin/zipalign -j0 build/$(model).llamafile models/$(model).gguf build/.args LICENSE-Llama-3.1 LICENSE-Llama-3.2
	chmod a+x build/$(model).llamafile

.PHONY: build-docker
build-docker: build
	docker build --platform linux/amd64,linux/arm64 -t maragudk/`echo $(model) | tr A-Z a-z`:latest .

.PHONY: clean
clean:
	rm -rf build
	rm -f llama.log

.PHONY: clean-all
clean-all: clean
	rm -rf llamafile
	rm -rf models

.PHONY: download
download:
	mkdir -p models
	cd models && curl -L -O -C - https://assets.maragu.dev/llm/$(model).gguf

llamafile/bin/llamafile:
	curl -L -O -C - https://github.com/Mozilla-Ocho/llamafile/releases/latest/download/llamafile-$(llamafile_version).zip
	unzip llamafile-$(llamafile_version).zip
	rm -f llamafile-$(llamafile_version).zip
	mv llamafile-$(llamafile_version) llamafile

.PHONY: start
start:
	./build/$(model).llamafile

.PHONY: upload
upload:
	AWS_PROFILE=r2 aws s3 cp models/$(model).gguf s3://maragudev/llm/
	AWS_PROFILE=r2 aws s3 cp build/$(model).llamafile s3://maragudev/llm/

# llamafile

Scripts for creating [llamafiles](https://github.com/Mozilla-Ocho/llamafile) for [Llama LLMs](https://www.llama.com) and other models in GGUF format.

## Usage

Check the `Makefile` for what version of Llamafile and what model will be used, and adjust to your liking.

To create a llamafile:

```shell
make build/$MODEL_NAME
```

To run the Llamafile:

```shell
make start
```

Made with ✨sparkles✨ by [maragu](https://www.maragu.dev/).

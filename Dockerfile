FROM debian:stable-slim AS runner

WORKDIR /bin

ARG LICENSE=LICENSE-Llama-3.2
COPY ${LICENSE} ./
COPY build/*.llamafile ./model

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "./model"]

CMD ["--server", "--v2", "--listen", "0.0.0.0:8080"]

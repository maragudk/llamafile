FROM debian:stable-slim AS runner

WORKDIR /bin

COPY LICENSE* ./
COPY build/*.llamafile ./model

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "./model"]

CMD ["--host", "0.0.0.0"]

FROM golang:buster as build-env
## Download and Extract
ADD https://github.com/gotify/server/archive/v2.0.17.tar.gz ./
RUN tar -xzavf v2.0.17.tar.gz

RUN cd server-2.0.17 && go build -a -o ../gotify-app .

FROM ubuntu

WORKDIR /app/

COPY --from=build-env /go/gotify-app ./
ENV GOTIFY_SERVER_PORT="80"
HEALTHCHECK --interval=60s --timeout=15s --start-period=60s CMD curl --fail http://localhost:$GOTIFY_SERVER_PORT/health || exit 1
EXPOSE 80
ENTRYPOINT ["./gotify-app"]

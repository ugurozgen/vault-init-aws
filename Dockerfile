FROM golang:1.21.4 AS build-stage
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /vault-init

FROM gcr.io/distroless/base-debian11 AS build-release-stage
COPY --from=build-stage /vault-init /vault-init
ENTRYPOINT ["/vault-init"]

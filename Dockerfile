FROM golang:1.21.4 AS build-stage
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /vault-init

FROM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN yum install -y shadow-utils && \
    adduser newuser && \
    mkdir /app && \
    yum remove -y shadow-utils
COPY --from=build-stage /vault-init /app/vault-init
RUN chown -R newuser:newuser /app
USER newuser
ENTRYPOINT ["/app/vault-init"]

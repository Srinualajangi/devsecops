FROM golang:1.20-alpine AS builder
WORKDIR /workspace
COPY go.mod ./
COPY *.go ./
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o dispatch .
FROM alpine:3.17
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
WORKDIR /app
COPY --from=builder /workspace/dispatch .
USER roboshop
EXPOSE 8080
CMD [./dispatch]

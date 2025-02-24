# Stage 1: Build the Go app
FROM golang:1.24 AS builder

WORKDIR /app

# Copy Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application (important: static binary!)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app main.go

# Stage 2: Create a small image with only the compiled binary
FROM alpine:latest

WORKDIR /root/

# Copy the compiled binary from the builder stage
COPY --from=builder /app/app .

# Give execute permission (if needed)
RUN chmod +x ./app

EXPOSE 5000


# Run the binary
CMD ["./app"]

# Use a minimal Go image as the base
FROM golang:1.24.0 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
RUN go build -o app main.go

# Use a smaller image for the final container
FROM alpine:latest

# Set the working directory
WORKDIR /root/

# Copy the built app from the builder stage
COPY --from=builder /app/app .

# Expose the port the app runs on
EXPOSE 5000

# Run the Go application
CMD ["./app"]

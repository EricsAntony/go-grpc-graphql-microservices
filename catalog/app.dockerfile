# Build stage
FROM golang:1.23.2-alpine AS build

# Install dependencies for building Go applications
RUN apk --no-cache add gcc g++ make ca-certificates

# Set the working directory for your project
WORKDIR /go/src/github.com/EricsAntony/go-grpc-graphql-microservices

# Copy Go module files and vendor directory
COPY go.mod go.sum ./
COPY catalog catalog

# Build the Go application with vendor mode enabled
RUN GO111MODULE=on go build -mod=mod -o /go/bin/app ./catalog/cmd/catalog

# Runtime stage
FROM alpine

# Set the working directory for the runtime container
WORKDIR /usr/bin

# Copy the built binary from the build stage
COPY --from=build /go/bin .

# Expose the application on port 8080
EXPOSE 8080

# Command to run the application
CMD ["app"]

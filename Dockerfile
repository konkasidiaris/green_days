# Use the official Elixir image
FROM elixir:1.17.2-alpine

# Install any dependencies needed by your Elixir CLI app
RUN apk add --no-cache --update \
    openssl \
    gnupg \
    git \
    pinentry

# Set the working directory
WORKDIR /app

# Copy your CLI app to the container
COPY . .

# Install the Elixir dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Compile the application
RUN mix escript.build

# Set the entry point to run your CLI application
ENTRYPOINT ["/app/green_days"]
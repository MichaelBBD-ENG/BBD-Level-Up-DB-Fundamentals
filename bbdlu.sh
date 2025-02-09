#!/bin/bash

# Show usage help
function show_help {
    echo "Usage: $0 [OPTIONS] COMMAND"
    echo ""
    echo "Options:"
    echo "  --help, -h        Show this help message"
    echo "  --version         Show version information"
    echo ""
    echo "Commands:"
    echo "  encrypt-env       Encrypt all env (local and prod)"
    echo "  decrypt-env       Decrypt all env (local and prod)"
    echo "  docker-up         Start all docker containers used by this project"
    echo "  docker-status     Show the status of all docker containers"
    echo "  flyway-info       Display the Flyway migration status"
    echo "  flyway-migrate    Perform Flyway migrations to the next version"
}

# Encrypt environment files
function encrypt_env {
    openssl enc -aes-256-cbc -salt -pbkdf2 -in secrets/local.env -out secrets/local.env.enc
    openssl enc -aes-256-cbc -salt -pbkdf2 -in secrets/prod.env -out secrets/prod.env.enc
}

# Decrypt environment files
function decrypt_env {
    openssl enc -aes-256-cbc -d -salt -pbkdf2 -in secrets/local.env.enc -out secrets/local.env
    openssl enc -aes-256-cbc -d -salt -pbkdf2 -in secrets/prod.env.enc -out secrets/prod.env
}

# Show version
function show_version {
    echo "CLI Template Version 0.1.0"
}

# Start Docker containers
function docker_up {
    docker compose -f docker/docker-compose.yml up -d
}

# Show status of Docker containers
function docker_status {
    docker ps -a
}

# Show Flyway migration status
function flyway_info {
    flyway -configFiles=flyway.conf info
}

# Perform Flyway migrations
function flyway_migrate {
    flyway -configFiles=flyway.conf migrate
}

# Command-line parsing
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
elif [[ "$1" == "--version" || "$1" == "-v" ]]; then
    show_version
elif [[ "$1" == "encrypt-env" ]]; then
    encrypt_env
elif [[ "$1" == "decrypt-env" ]]; then
    decrypt_env
elif [[ "$1" == "docker-up" ]]; then
    docker_up
elif [[ "$1" == "docker-status" ]]; then
    docker_status
elif [[ "$1" == "flyway-info" ]]; then
    flyway_info
elif [[ "$1" == "flyway-migrate" ]]; then
    flyway_migrate
else
    echo "Invalid option or command. Use --help for usage information."
    exit 1
fi

#!/bin/bash

# Show usage help
function show_help {
    echo "Usage: $0 [OPTIONS] COMMAND"
    echo ""
    echo "Options:"
    echo "  --help, -h                                      Show this help message"
    echo "  --version                                       Show version information"
    echo ""
    echo "Commands:"
    echo "  docker-up                                       Start all docker containers used by this project"
    echo "  docker-status                                   Show the status of all docker containers"
    echo "  flyway-info                                     Display the Flyway migration status"
    echo "  flyway-migrate                                  Perform Flyway migrations to the next version"
    echo "  gen-insert table csv_file output_sql_file       Generate insert statments whilst taking in the table, csv file into an sql file"
    echo "         eg: ./bbdlu.sh gen-insert users csv/insert.csv sql/VXX__insert_users_and_contact_info.sql"
}

# Show version
function show_version {
    echo "bbdlu Version 0.1.0"
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
    flyway -configFiles=flyway.toml -url=jdbc:postgresql://localhost:5432/MagicBeanDB -user=root -password=root info
}

# Perform Flyway migrations
function flyway_migrate {
    flyway -configFiles=flyway.toml -url=jdbc:postgresql://localhost:5432/MagicBeanDB -user=root -password=root migrate
}

# Command-line parsing
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
elif [[ "$1" == "--version" || "$1" == "-v" ]]; then
    show_version
elif [[ "$1" == "docker-up" ]]; then
    docker_up
elif [[ "$1" == "docker-status" ]]; then
    docker_status
elif [[ "$1" == "flyway-info" ]]; then
    flyway_info
elif [[ "$1" == "flyway-migrate" ]]; then
    flyway_migrate
elif [[ "$1" == "gen-insert" ]]; then
    python insert_statements.py "$2" "$3" "$4" 
else
    echo "Invalid option or command. Use --help for usage information."
    exit 1
fi


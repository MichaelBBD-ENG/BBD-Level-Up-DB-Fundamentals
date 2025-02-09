@echo off
setlocal

:: Show usage help
if "%1"=="--help" (
    call :show_help
    goto end
)
if "%1"=="-h" (
    call :show_help
    goto end
)

:: Show version info
if "%1"=="--version" (
    call :show_version
    goto end
)
if "%1"=="-v" (
    call :show_version
    goto end
)

:: Encrypt environment files
if "%1"=="encrypt-env" (
    call :encrypt_env
    goto end
)

:: Decrypt environment files
if "%1"=="decrypt-env" (
    call :decrypt_env
    goto end
)

:: Docker up
if "%1"=="docker-up" (
    call :docker_up
    goto end
)

:: Docker status
if "%1"=="docker-status" (
    call :docker_status
    goto end
)

:: Flyway info
if "%1"=="flyway-info" (
    call :flyway_info
    goto end
)

:: Flyway migrate
if "%1"=="flyway-migrate" (
    call :flyway_migrate
    goto end
)

:: If no valid command is passed
echo Invalid option or command. Use --help for usage information.
goto end


:: Functions

:show_help
echo Usage: %0 [OPTIONS] COMMAND
echo.
echo Options:
echo   --help, -h        Show this help message
echo   --version         Show version information
echo.
echo Commands:
echo   encrypt-env       Encrypt all env (local and prod)
echo   decrypt-env       Decrypt all env (local and prod)
echo   docker-up         Start all docker containers used by this project
echo   docker-status     Show the status of all docker containers
echo   flyway-info       Display the Flyway migration status
echo   flyway-migrate    Perform Flyway migrations to the next version
goto :eof

:show_version
echo bbdlu Version 0.1.0
goto :eof

:encrypt_env
:: Encrypt the environment files
openssl enc -aes-256-cbc -salt -pbkdf2 -in secrets\local.env -out secrets\local.env.enc
openssl enc -aes-256-cbc -salt -pbkdf2 -in secrets\prod.env -out secrets\prod.env.enc
goto :eof

:decrypt_env
:: Decrypt the environment files
openssl enc -aes-256-cbc -d -salt -pbkdf2 -in secrets\local.env.enc -out secrets\local.env
openssl enc -aes-256-cbc -d -salt -pbkdf2 -in secrets\prod.env.enc -out secrets\prod.env
goto :eof

:docker_up
:: Start the Docker containers
docker compose -f docker\docker-compose.yml up -d
goto :eof

:docker_status
:: Show the status of all Docker containers
docker ps -a
goto :eof

:flyway_info
:: Display the Flyway migration status
flyway -configFiles=flyway.conf info
goto :eof

:flyway_migrate
:: Perform Flyway migrations
flyway -configFiles=flyway.conf migrate
goto :eof

:end
endlocal

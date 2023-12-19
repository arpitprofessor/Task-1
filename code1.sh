#!/bin/bash

# Define the version
VERSION="v0.1.0"

# Display version
function display_version() {
    echo "internsctl version $VERSION"
}

# Display help
function display_help() {
    echo "Usage: internsctl [OPTIONS] COMMAND"
    echo "A simple command for managing interns."
    echo
    echo "Options:"
    echo "  --version     Display the version"
    echo "  --help        Display this help message"
    echo
    echo "Commands:"
    echo "  cpu getinfo       Display CPU information (similar to lscpu)"
    echo "  memory getinfo    Display memory information (similar to free)"
    echo "  user create       Create a new user"
    echo "  user list         List all regular users"
    echo "  user list --sudo-only List all users with sudo permissions"
    echo "  file getinfo      Get information about a file"
    # Add more commands and descriptions as needed
}

# Function to get CPU information
function get_cpu_info() {
    lscpu
}

# Function to get memory information
function get_memory_info() {
    free
}

# Function to create a new user
function create_user() {
    if [ -z "$1" ]; then
        echo "Error: Username not provided."
        exit 1
    fi

    # Check if the user already exists
    if id "$1" &>/dev/null; then
        echo "Error: User '$1' already exists."
        exit 1
    fi

    sudo useradd -m -s /bin/bash "$1"
    sudo passwd "$1"
    echo "User $1 created successfully."
}

# Function to list all regular users
function list_users() {
    cut -d: -f1 /etc/passwd
}

# Function to list users with sudo permissions
function list_sudo_users() {
    getent group sudo | cut -d: -f4 | tr ',' '\n'
}

# Function to get file information
function get_file_info() {
    local file=$1
    local size_option=false
    local permissions_option=false
    local owner_option=false
    local last_modified_option=false

    # Parse command-line options for file info
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --size|-s)
                size_option=true
                ;;
            --permissions|-p)
                permissions_option=true
                ;;
            --owner|-o)
                owner_option=true
                ;;
            --last-modified|-m)
                last_modified_option=true
                ;;
            *)
                # Assume the remaining arguments are the filename
                file=$1
                ;;
        esac
        shift
    done

    # Display specific file information based on options
    if [ "$size_option" = true ]; then
        du -b "$file" | cut -f1
    elif [ "$permissions_option" = true ]; then
        stat --format=%A "$file"
    elif [ "$owner_option" = true ]; then
        stat --format=%U "$file"
    elif [ "$last_modified_option" = true ]; then
        stat --format=%y "$file"
    else
        # Default file information
        echo "File: $file"
        echo "Access: $(stat --format=%A "$file")"
        echo "Size(B): $(du -b "$file" | cut -f1)"
        echo "Owner: $(stat --format=%U "$file")"
        echo "Modify: $(stat --format=%y "$file")"
    fi
}

# Main function
function main() {
    # Parse command-line options
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --version)
                display_version
                exit 0
                ;;
            --help)
                display_help
                exit 0
                ;;
            cpu)
                shift
                case $1 in
                    getinfo)
                        get_cpu_info
                        exit 0
                        ;;
                    *)
                        echo "Error: Unknown subcommand for 'cpu': $1"
                        display_help
                        exit 1
                        ;;
                esac
                ;;
            memory)
                shift
                case $1 in
                    getinfo)
                        get_memory_info
                        exit 0
                        ;;
                    *)
                        echo "Error: Unknown subcommand for 'memory': $1"
                        display_help
                        exit 1
                        ;;
                esac
                ;;
            user)
                shift
                case $1 in
                    create)
                        shift
                        create_user "$1"
                        exit 0
                        ;;
                    list)
                        shift
                        if [ "$1" == "--sudo-only" ]; then
                            list_sudo_users
                        else
                            list_users
                        fi
                        exit 0
                        ;;
                    *)
                        echo "Error: Unknown subcommand for 'user': $1"
                        display_help
                        exit 1
                        ;;
                esac
                ;;
            file)
                shift
                case $1 in
                    getinfo)
                        shift
                        get_file_info "$@"
                        exit 0
                        ;;
                    *)
                        echo "Error: Unknown subcommand for 'file': $1"
                        display_help
                        exit 1
                        ;;
                esac
                ;;
            *)
                echo "Error: Unknown option or command: $1"
                display_help
                exit 1
                ;;
        esac
        shift
    done
}

# Run the main function with command-line arguments
main "$@"
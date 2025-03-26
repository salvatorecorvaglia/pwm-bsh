#!/bin/bash

# Define the file to store encrypted passwords
PASSWORD_FILE="passwords.enc"

# Ask for a master passphrase to encrypt/decrypt passwords
MASTER_PASSWORD=""

# Function to encrypt and store a password
store_password() {
    echo "Enter the service name (e.g., website name):"
    read service
    echo "Enter the password for $service:"
    read -s password
    echo "$service:$password" | openssl enc -aes-256-cbc -salt -pass pass:"$MASTER_PASSWORD" -out "$PASSWORD_FILE"
    echo "Password for $service stored securely!"
}

# Function to retrieve and decrypt a password
retrieve_password() {
    echo "Enter the service name to retrieve the password for:"
    read service
    decrypted=$(openssl enc -aes-256-cbc -d -in "$PASSWORD_FILE" -pass pass:"$MASTER_PASSWORD" 2>/dev/null | grep -i "$service")
    if [ -z "$decrypted" ]; then
        echo "Password not found for $service!"
    else
        echo "Password for $service is:"
        echo "$decrypted" | cut -d: -f2
    fi
}

# Function to list all stored services
list_passwords() {
    echo "Stored passwords for the following services:"
    openssl enc -aes-256-cbc -d -in "$PASSWORD_FILE" -pass pass:"$MASTER_PASSWORD" 2>/dev/null | cut -d: -f1
}

# Main menu
echo "Enter your master password for encryption/decryption:"
read -s MASTER_PASSWORD

echo "Welcome to the Password Manager"
echo "1. Store a password"
echo "2. Retrieve a password"
echo "3. List stored passwords"
echo "4. Exit"
read choice

case $choice in
    1)
        store_password
        ;;
    2)
        retrieve_password
        ;;
    3)
        list_passwords
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice! Exiting..."
        exit 1
        ;;
esac


#!/bin/bash

# Define the file to store encrypted passwords
PASSWORD_FILE="passwords.enc"

# Ask for a master passphrase to encrypt/decrypt passwords
MASTER_PASSWORD=""

# Function to encrypt and store a password and username
store_password() {
    echo "Enter the service name (e.g., website name):"
    read service
    echo "Enter the username for $service:"
    read username
    echo "Enter the password for $service:"
    read -s password
    echo "$service:$username:$password" | openssl enc -aes-256-cbc -salt -pass pass:"$MASTER_PASSWORD" >> "$PASSWORD_FILE"
    echo "Username and password for $service stored securely!"
}

# Function to retrieve and decrypt a password and username
retrieve_password() {
    echo "Enter the service name to retrieve the username and password for:"
    read service
    decrypted=$(openssl enc -aes-256-cbc -d -in "$PASSWORD_FILE" -pass pass:"$MASTER_PASSWORD" 2>/dev/null | grep -i "$service")
    
    if [ -z "$decrypted" ]; then
        echo "Username and password not found for $service or decryption failed!"
    else
        echo "Username and password for $service are:"
        echo "$decrypted" | cut -d: -f2,3
    fi
}

# Function to list all stored services with their usernames
list_passwords() {
    if [ ! -f "$PASSWORD_FILE" ] || [ ! -s "$PASSWORD_FILE" ]; then
        echo "No stored passwords found."
        return
    fi

    echo "Stored usernames and passwords for the following services:"
    openssl enc -aes-256-cbc -d -in "$PASSWORD_FILE" -pass pass:"$MASTER_PASSWORD" 2>/dev/null | cut -d: -f1,2
}

# Check if the password file exists and set permissions if it does
if [ -f "$PASSWORD_FILE" ]; then
    chmod 600 "$PASSWORD_FILE"
fi

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

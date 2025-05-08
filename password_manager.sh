#!/bin/bash

# Encrypted password storage file
PASSWORD_FILE="passwords.enc"

# Temporary file for decrypted data (auto-deleted on exit)
TEMP_FILE=$(mktemp)
trap "rm -f $TEMP_FILE" EXIT

# Prompt user for the master password
echo "Enter your master password:"
read -s MASTER_PASSWORD

# Function to decrypt the encrypted password file into TEMP_FILE
decrypt_file() {
    if [ -f "$PASSWORD_FILE" ]; then
        openssl enc -aes-256-cbc -d -in "$PASSWORD_FILE" -pass pass:"$MASTER_PASSWORD" -out "$TEMP_FILE" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "Failed to decrypt password file. Wrong password or corrupted file."
            exit 1
        fi
    else
        touch "$TEMP_FILE"
    fi
}

# Function to encrypt TEMP_FILE back into PASSWORD_FILE
encrypt_file() {
    openssl enc -aes-256-cbc -salt -pass pass:"$MASTER_PASSWORD" -in "$TEMP_FILE" -out "$PASSWORD_FILE"
    chmod 600 "$PASSWORD_FILE"  # Restrict file permissions
}

# Store a new username/password entry
store_password() {
    decrypt_file
    echo "Enter service name:"
    read service
    echo "Enter username:"
    read username
    echo "Enter password:"
    read -s password
    echo "$service:$username:$password" >> "$TEMP_FILE"
    encrypt_file
    echo "Stored successfully."
}

# Retrieve a username/password by service name
retrieve_password() {
    decrypt_file
    echo "Enter service name:"
    read service
    grep -i "^$service:" "$TEMP_FILE" | while IFS=: read -r s u p; do
        echo "Username: $u"
        echo "Password: $p"
    done
}

# List all stored service names
list_passwords() {
    decrypt_file
    echo "Stored services:"
    cut -d: -f1 "$TEMP_FILE" | sort | uniq
}

# Main menu
echo "Welcome to the Password Manager"
echo "1. Store a password"
echo "2. Retrieve a password"
echo "3. List stored services"
echo "4. Exit"
read choice

case $choice in
    1) store_password ;;
    2) retrieve_password ;;
    3) list_passwords ;;
    4) echo "Goodbye!" ;;
    *) echo "Invalid option" ;;
esac
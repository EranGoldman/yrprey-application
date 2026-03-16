#!/bin/bash
set -e

# Set default environment variables if not set externally
: "${MYSQL_ROOT_PASSWORD:=rootpassword}"
: "${MYSQL_DATABASE:=notesappdb}"
: "${MYSQL_USER:=notesuser}"
: "${MYSQL_PASSWORD:=notespwd}"

echo "Using MYSQL_ROOT_PASSWORD=[HIDDEN]"
echo "Using MYSQL_DATABASE=${MYSQL_DATABASE}"
echo "Using MYSQL_USER=${MYSQL_USER}"
echo "Using MYSQL_PASSWORD=[HIDDEN]"

# Ensure MariaDB data directory ownership and permissions
chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql

# Function to run command as mysql user if possible
run_as_mysql() {
  if command -v su-exec >/dev/null 2>&1; then
    su-exec mysql "$@"
  elif command -v gosu >/dev/null 2>&1; then
    gosu mysql "$@"
  else
    # fallback to run directly (not recommended)
    "$@"
  fi
}

# Initialize the MariaDB data directory if it's empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  if command -v mysql_install_db >/dev/null 2>&1; then
    echo "Running mysql_install_db as user 'mysql'..."
    run_as_mysql mysql_install_db --datadir=/var/lib/mysql > /dev/null 2>&1 || {
      echo "mysql_install_db failed to run."
      exit 1
    }
  else
    echo "mysql_install_db command not found."
    exit 1
  fi

  echo "Starting MariaDB temporary server for initial setup..."
  run_as_mysql mysqld --skip-networking --socket=/tmp/mysql.sock &
  pid="$!"

  # Wait for MariaDB server to start
  echo "Waiting for MariaDB server to start up..."
  for i in {30..0}; do
    if mysqladmin ping --socket=/tmp/mysql.sock --silent; then
      echo "MariaDB server is up!"
      break
    fi
    echo "Waiting for MariaDB server to start... ($i)"
    sleep 1
  done

  if [ "$i" = 0 ]; then
    echo "MariaDB server failed to start."
    exit 1
  fi

  # Create default database and user
  echo "Creating default database and user..."
  if ! mysql --socket=/tmp/mysql.sock <<-EOSQL
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
    FLUSH PRIVILEGES;
EOSQL
  then
    echo "Failed to create database and user."
    echo "Check the MariaDB error log for more details."
    exit 1
  fi

  echo "Shutting down temporary MariaDB server..."
  mysqladmin --socket=/tmp/mysql.sock shutdown

else
  echo "MariaDB data directory already initialized."
fi

# echo "Starting supervisor to manage MariaDB process..."
exec supervisord
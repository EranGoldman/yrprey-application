#!/bin/bash

# Espera o MariaDB estar pronto

# Criação do banco de dados
echo "Criando banco de dados wall..."
mysql -u root -pyrprey -e "CREATE DATABASE IF NOT EXISTS wall CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"

# Importação do arquivo SQL
echo "Importando dump.sql para wall..."
mysql -u root -pyrprey wall < /scripts/dump.sql

echo "Banco de dados criado e dump importado com sucesso."

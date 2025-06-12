#!/bin/bash


echo "Iniciando o serviço do MySQL..."
service mysql start

echo "Aguardando o MySQL inicializar (sem senha)..."
# Fase 1: aguarda MySQL aceitar conexões antes da configuração de senha
while ! mysqladmin ping --silent; do
    sleep 2
    echo "Esperando o MySQL (sem senha)..."
done

echo "MySQL acessível. Executando configuração segura (define senha)..."
/scripts/secure_mysql.sh

service mysql restart

sleep 1

echo "Aguardando o MySQL reinicializar (com senha)..."
# Fase 2: aguarda MySQL aceitar conexões com senha root já definida
while ! mysqladmin ping -u root -p123456 --silent; do
    sleep 2
    echo "Esperando o MySQL (com senha)..."
done


# Executa script de inicialização do banco
echo "Executando init_db.sh..."
/scripts/init_db.sh


sleep 2

if [ -S /var/run/mysqld/mysqld.sock ]; then
    echo "Socket do MySQL existe. Executando comandos..."
    service mysql stop
else
    echo "MySQL não está rodando ou socket está ausente."
fi

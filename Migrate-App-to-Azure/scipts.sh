#!/bin/bash

# Variables
resourceGroup="az-dev-prj3"
location="eastus"
tag="create-postgresql-server-and-firewall-rule"
osType="UbuntuLTS"
storageAccount="migrateappacct"
storageType="Standard_LRS"
serviceBus="serviceBusPJ3"
serviceBusQueue="serviceBusQueue"
serverPostgres="az-prj3-postgresql-server"
appServiceName="app-service-pj3"
sku="GP_Gen5_2"
login="azpj3"
password="Admin1234"
# Specify appropriate IP address values for your environment
# to limit / allow access to the PostgreSQL server
startIp=0.0.0.0
endIp=0.0.0.0

# 1. Create resource group. 
echo "Step 0 - Creating resource group $resourceGroup..."
az group create --name az-dev-prj3 --location eastus --tags create-postgresql-server-and-firewall-rule

# 2. Create an Azure Postgres Database single server. 
# Create a PostgreSQL server in the resource group
# Name of a server maps to DNS name and is thus required to be globally unique in Azure.
echo "Step 1 creating $serverPostgres in $location..."
az postgres server create --name az-prj3-postgresql-server --resource-group az-dev-prj3 --location eastus --admin-user azpj3 --admin-password Admin1234 --sku-name GP_Gen5_2

# Configure a firewall rule for the server 
echo "Configuring a firewall rule for $serverPostgres for the IP address range of $startIp to $endIp"
az postgres server firewall-rule create --resource-group az-dev-prj3 --server az-prj3-postgresql-server --name AllowIps --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# List firewall rules for the server
echo "List of server-based firewall rules for $serverPostgres"
az postgres server firewall-rule list --resource-group az-dev-prj3 --server-name az-prj3-postgresql-server
# You may use the switch `--output table` for a more readable table format as the output.

# connect az postgres
#psql --host=<server_name>.postgres.database.azure.com --port=5432 --username=<admin_user>@<server_name> --dbname=postgres
psql --host=az-prj3-postgresql-server.postgres.database.azure.com --port=5432 --username=azpj3@az-prj3-postgresql-server --dbname=postgres
az postgres server update --resource-group az-dev-prj3 --name az-prj3-postgresql-server --ssl-enforcement Disabled 

# 3. Create a Service Bus resource with a notificationqueue that will be used to communicate between the web and the function
echo "Step 3 creating servicebus $serviceBus in $location..."
az servicebus namespace create --resource-group az-dev-prj3 --name serviceBusPJ3 --location eastus

az servicebus queue create --resource-group az-dev-prj3 --namespace-name serviceBusPJ3 --name serviceBusQueue
# Run the following command to get the primary connection string for the namespace. 
# You use this connection string to connect to the queue and send and receive messages.
az servicebus namespace authorization-rule keys list --resource-group az-dev-prj3  --namespace-name serviceBusPJ3 --name RootManageSharedAccessKey --query primaryConnectionString --output tsv

#output: Endpoint=sb://servicebuspj3.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=kjq6iPcpuATjk1SWtBDx+xV7F70JNVqcd+ASbC7HPnE=
# 4. Create App Service plan
az appservice plan create -g az-dev-prj3  -n app-service-pj3 --is-linux --number-of-workers 4 --sku S1

# 5. Create a storage account
az storage account create --name migrateappacct --resource-group az-dev-prj3  --location eastus
az storage container create --account-name migrateappacct --name images --auth-mode login --public-access container
az storage account keys list --account-name migrateappacct --resource-group az-dev-prj3 

# az webapp deploy --resource-group <group-name> --name <app-name> --src-path <zip-package-path>

az webapp deploy --resource-group az-dev-prj3 --name app-service-pj3 --src-path ./Migrate-App-to-Azure.zip
az webapp up -n app-service-pj3 -g az-dev-prj3 --runtime "PYTHON:3.9" -l eastus --logs -p appservicepj3 --sku B2

#!/bin/bash

WORKSPACE=${1:-"workspace"}

echo -e "\nRetrieving environment variables from Epinio services...\n"

AMQP_URI="amqp://guest:guest@$WORKSPACE-rabbit-rabbitmq.$WORKSPACE.svc.cluster.local:5672"
export AMQP_URI

POSTGRES_URI="postgresql://postgres:postgres@$WORKSPACE-postgres-postgresql.$WORKSPACE.svc.cluster.local:5432/devex"
export POSTGRES_URI

REDIS_URI="redis://$WORKSPACE-redis-redis.$WORKSPACE.svc.cluster.local:6379"
export REDIS_URI

# Comment the line below if you don't want to use FastAPI.
export FASTAPI=X

# Database creation 
python -c """
import psycopg2 as db
from urllib.parse import urlparse
result = urlparse('${POSTGRES_URI}')
username = result.username
password = result.password
database = result.path[1:]
hostname = result.hostname
port = result.port
con=db.connect(dbname='postgres',host=hostname,user=username,password=password)
con.autocommit=True;con.cursor().execute('CREATE DATABASE devex')
"""

./run.sh "$@"

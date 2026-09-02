# Create Docker network so the containers can see each other
docker network create pg-network

# later remove it with
docker network rm pg-network

# look at the existing networks with 
docker network ls

# Run PostgreSQL on the network --> pgdatabase
docker run -it --rm \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v ny_taxi_postgres_data:/var/lib/postgresql \
  -p 5432:5432 \
  --network=pg-network \
  --name pgdatabase \
  postgres:18


# In another terminal, run pgAdmin on the same network --> pgadmin
docker run -it --rm \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -v pgadmin_data:/var/lib/pgadmin \
  -p 8085:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4


# Dockerizing the Ingestion Script

# build the docker image for ingestion
docker build -t taxi_ingest:v001 .

# run the containerized ingestion
docker run -it --rm \
    --network=pg-network \
    taxi_ingest:v001 \
    --pg-user=root \
    --pg-pass=root \
    --pg-host=pgdatabase \
    --pg-port=5432 \
    --pg-db=ny_taxi \
    --target-table=yellow_taxi_trips_2021_02 \
    --year=2021 \
    --month=2 \
    --chunksize=100000


# Replace these multiple docker run with Docker Compose
# create docker-compose.yaml
# run in detached mode
docker-compose up -d

# later stop the services with
docker-compose down

# docker compose created a network under different name
# find it under this list
docker network ls

# network name is pipeline_default, so the ingestion container will be run with:
docker run -it --rm \
  --network=pipeline_default \
  taxi_ingest:v001 \
    --pg-user=root \
    --pg-pass=root \
    --pg-host=pgdatabase \
    --pg-port=5432 \
    --pg-db=ny_taxi \
    --target-table=yellow_taxi_trips


# Cleanup Docker resources to free up disk space

# stop all running containers
docker-compose down


# Remove specific containers
# list all containers
docker ps -a

# remove specific container
docker rm <container_id>

# remove all listed containers
docker rm $(docker ps -aq)

# remove all stopped containers
docker container prune


# Remove Docker Images
# list all images
docker images

# remove specific image
docker rmi taxi_ingest:v001

# remove all unused images
docker image prune -a


# Remove Docker volumes
# List volumes
docker volume ls

# Remove specific volumes
docker volume rm ny_taxi_postgres_data
docker volume rm pgadmin_data

# Remove all unused volumes
docker volume prune


# Remove Docker Networks
# list networks
docker network ls

# remove specific network
docker network rm pg-network

# remove all unused networks
docker network prune


# Complete Cleanup
# ⚠️ Warning: This removes ALL Docker resources!
docker system prune -a --volumes


# Clean up local files
# remove parquet files
rm *.parquet

# remove Python cache
rm -rf __pycache__ .pytest_cache

# remove virtual environment (if using venv)
rm -rf .venv
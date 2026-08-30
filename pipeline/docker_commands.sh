# Create Docker network so the containers can see each other
docker network create pg-network

# later remove it with
docker network rm pg-network

# look at the existing networks with 
docker network ls

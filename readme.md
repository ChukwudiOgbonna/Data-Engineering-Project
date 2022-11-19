# postgres database
 docker run -it \
 -e POSTGRES_USER= "root" \
 -e POSTGRES_PASSWORD="root" \
 -e POSTGRES_DB= "ny_taxi"\
 -p 5432:5432 \ 
 -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
 -d postgres:13
# pgadmin GUI tool
docker run -it \                
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  dpage/pgadmin4:latest

# the pgadmin tool container cannot connect to the postgres database container because it can only access what is in pgadmin tool container
# docker containers cannot see the computer localhost, because containers refer to themselves as localhost
# to allow communication between two independent containers, we place both containers in the same network
   
docker create network pg-network
# then add both to the same network
# postgres database with network
# --name :this shows the name other containers can use to access the database container
 docker run -it \
 -e POSTGRES_USER= "root" \
 -e POSTGRES_PASSWORD="root" \
 -e POSTGRES_DB= "ny_taxi"\
 -p 5432:5432 \ 
 -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
 --network=pg-network \
 --name= pg-datbase \
 -d postgres:latest

 # pgadmin GUI tool with network

 docker run -it \                
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network= pg-network
  dpage/pgadmin4:latest

# ingest python script using python, pass arguments to our python script
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

python ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=${URL}


 # ingest python script using docker image
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

# -- before the image are parameters passed to docker, -- after the image name are parameters passed to the image, in this case the python script.
docker run -it \
  --network=pg-network \ 
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}

# create a http server and put our static files on that server, runs on localhost:8000
# this allows us to retrieve our csv file from this server instead of downloaodng it from the internet
python -m http.server

# Running these containers with a container orchestration tool called Docker Compose
# docker compose automatically allows containers to communicate, so no need of defining network, just use the service name to communcate with a container. Use bind mounts to preserve database data, and pg admin configurations

services:
  pgdatabase:
    image: postgres:13
    environment:
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=ny_taxi
    volumes:
      - "./ny_taxi_postgres_data:/var/lib/postgresql/data:rw"
    ports:
      - "5432:5432"
  pgadmin:
    image: dpage/pgadmin4
    environment:
      - PGADMIN_DEFAULT_EMAIL=admin@admin.com
      - PGADMIN_DEFAULT_PASSWORD=root
    volumes:
      - ./pgadmin_data:/var/lib/pgadmin
    ports:
      - "8080:80"
    

# docker command to ingest data
docker run -it \
  -e username="root" \
  -e password="root" \
  -e host="pg-database" \
  -e port=5432 \
  -e database="ny_taxi" \
  -e tablename="zones" \
  -e url="https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv" \
  --network=docker_default ingest_data:v001
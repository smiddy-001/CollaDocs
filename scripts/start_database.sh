MY_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORKSPACE_FOLDER=$MY_SCRIPT_DIR/..
CONFIG_FOLDER=$WORKSPACE_FOLDER/config
DOCS=$WORKSPACE_FOLDER/docs
CONFIG_YAML_FILE=$CONFIG_FOLDER/config.yaml
CONFIG_SCRIPT_FILE=$CONFIG_FOLDER/load_config.sh

source $CONFIG_SCRIPT_FILE --config $CONFIG_YAML_FILE --mode test
# source $CONFIG_SCRIPT_FILE --config $CONFIG_YAML_FILE --mode test


# Function to check if the Docker image exists
check_image_exists() {
  docker image inspect $1 > /dev/null 2>&1
  return $?
}

{
  docker ps -q
} || {
  echo
  echo "Docker is not running. Please start docker on your computer"
  echo "When docker has finished starting up press [ENTER] to continue"
  echo
  read
}

if check_image_exists $IMAGE_NAME; then
    #
    # oracle docker instance exists
    #
    echo "Docker image $IMAGE_NAME found. Running the container..."

    echo "Debug: IMAGE_NAME=$IMAGE_NAME"
    echo "Debug: DOCKER_NAME=$CONTAINER_NAME"
    echo "Debug: DB_NAME=$DB_NAME"
    echo "Debug: DB_PORT=$DB_PORT"
    echo "Debug: DB_USERNAME=$DB_USERNAME"
    echo "Debug: DB_PASSWORD=$DB_PASSWORD"
    echo "Debug: DB_HOST_MOUNT_POINT=$DB_HOST_MOUNT_POINT"

    # Check if container exists
    container_status=$(docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.Status}}")

    if [[ $container_status == *"Up"* ]]; then
        echo "The container $CONTAINER_NAME is already running."
    elif [[ $container_status == *"Exited"* ]]; then
        echo "The container $CONTAINER_NAME exists but is stopped. Starting it..."
        docker start $CONTAINER_NAME
    else
        echo "Container $CONTAINER_NAME does not exist. Creating and running the container..."
        docker run --name $CONTAINER_NAME \
            -p $DB_PORT:1521 \
            --ulimit nofile=1024:65536 \
            --ulimit nproc=2047:16384 \
            --ulimit stack=10485760:33554432 \
            --ulimit memlock=3221225472 \
            -e ORACLE_PWD=$DB_ADMIN_PASSWORD \
            -e ENABLE_ARCHIVELOG=true \
            -e ENABLE_FORCE_LOGGING=true \
            -e ORACLE_SID=$DB_SID \
            -e ORACLE_PWD=$DB_ADMIN_PASSWORD \
            -v $DB_HOST_MOUNT_POINT:/opt/oracle/oradata \
            $IMAGE_NAME

        docker exec -i $CONTAINER_NAME sqlplus $DB_ADMIN_USERNAME/$DB_ADMIN_PASSWORD@$DB_HOST:$DB_PORT/$DB_ADMIN_NAME as SYSDBA <<EOF
            alter user sys identified by $DB_ADMIN_USERNAME;
            EOF
        
        docker exec -i $CONTAINER_NAME sqlplus $ORACLE_USER/$DB_PASSWORD@localhost:$DB_PORT/$DB_NAME as $DB_USERNAME <<EOF
            CREATE USER $DB_USER_USERNAME IDENTIFIED BY $DB_USER_PASSWORD;
            GRANT CONNECT, RESOURCE TO $DB_USER_USERNAME;
            EXIT;
            EOF
        
    fi

else
    #
    # oracle docker instance does NOT exist
    #
    echo "Docker image $IMAGE_NAME not found. Please follow the steps in docs/init_database.md to initialize the database."
    echo
    cat $DOCS/init_database.md
    echo
fi

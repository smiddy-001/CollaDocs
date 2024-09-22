MY_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_FOLDER=$MY_SCRIPT_DIR/../../config/
CONFIG_YAML_FILE=$CONFIG_FOLDER/config.yaml
CONFIG_SCRIPT_FILE=$CONFIG_FOLDER/load_config.sh


source $CONFIG_SCRIPT_FILE --config $CONFIG_YAML_FILE --mode test
# source $CONFIG_SCRIPT_FILE --config $CONFIG_YAML_FILE --mode test


# Function to check if the Docker image exists
check_image_exists() {
  docker image inspect $1 > /dev/null 2>&1
  return $?
}


if check_image_exists $IMAGE_NAME; then
    #
    # oracle docker instance exists
    #
    echo "Docker image $IMAGE_NAME found. Running the container..."

    echo "Debug: IMAGE_NAME=$IMAGE_NAME"
    echo "Debug: DOCKER_NAME=$DOCKER_NAME"
    echo "Debug: DB_NAME=$DB_NAME"
    echo "Debug: DB_PORT=$DB_PORT"
    echo "Debug: DB_USERNAME=$DB_USERNAME"
    echo "Debug: DB_PASSWORD=$DB_PASSWORD"
    echo "Debug: DB_HOST_MOUNT_POINT=$DB_HOST_MOUNT_POINT"

    # Check if container exists
    container_status=$(docker ps -a --filter "name=$DOCKER_NAME" --format "{{.Status}}")

    if [[ $container_status == *"Up"* ]]; then
        echo "The container $DOCKER_NAME is already running."
    elif [[ $container_status == *"Exited"* ]]; then
        echo "The container $DOCKER_NAME exists but is stopped. Starting it..."
        docker start $DOCKER_NAME
    else
        echo "Container $DOCKER_NAME does not exist. Creating and running the container..."
        docker run --name $DOCKER_NAME \
            -p $DB_PORT:1521 \
            --ulimit nofile=1024:65536 \
            --ulimit nproc=2047:16384 \
            --ulimit stack=10485760:33554432 \
            --ulimit memlock=3221225472 \
            -e ORACLE_PWD=$DB_ADMIN_PASSWORD \
            -e ENABLE_ARCHIVELOG=true \
            -e ENABLE_FORCE_LOGGING=true \
            -e ORACLE_SID=$DB_SID \
            -e ORACLE_USER=$DB_USERNAME \
            -e ORACLE_PWD=$DB_PASSWORD \
            -v $DB_HOST_MOUNT_POINT:/opt/oracle/oradata \
            $IMAGE_NAME
    fi


else
    #
    # oracle docker instance does NOT exist
    #
    echo "Docker image $IMAGE_NAME not found. Please follow the steps in docs/init_database.md to initialize the database."
    cat $MY_SCRIPT_DIR/../../docs/init_database.md
fi

MY_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORKSPACE_FOLDER=$MY_SCRIPT_DIR/../..
CONFIG_FOLDER=$WORKSPACE_FOLDER/config
DOCS=$WORKSPACE_FOLDER/docs
CONFIG_YAML_FILE=$CONFIG_FOLDER/config.yaml
CONFIG_SCRIPT_FILE=$CONFIG_FOLDER/load_config.sh

source $CONFIG_SCRIPT_FILE --config $CONFIG_YAML_FILE --mode test
# source $CONFIG_SCRIPT_FILE --config $CONFIG_YAML_FILE --mode test

# Function to check if the Docker image exists
check_image_exists() {
  echo "Checking for image: $1"
  docker image inspect $1 > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    # exists
    return 0
  else
    # not exists
    return 1
  fi
}

{
  docker ps -q
} || {
  echo
  echo "Docker is not running. Please start docker on your computer"
  echo "When docker has finished starting up press [ENTER] to continue"
  read
}

if check_image_exists $IMAGE_NAME; then
    # oracle docker instance exists
    echo "Docker image $IMAGE_NAME found. Running the container..."

    echo "IMAGE_NAME=$IMAGE_NAME"
    echo "Debug: DOCKER_NAME=$CONTAINER_NAME"
    echo "Debug: DB_NAME=$DB_NAME"
    echo "Debug: DB_PORT=$DB_PORT"
    echo "Debug: DB_HOST_USERNAME=$DB_ADMIN_USERNAME"
    echo "Debug: DB_HOST_PASSWORD=$DB_ADMIN_PASSWORD"

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
            --ulimit nofile=$DB_NOFILE \
            --ulimit nproc=$DB_NPROC \
            --ulimit stack=$DB_STACK \
            --ulimit memlock=$DB_MEMLOCK \
            -e ORACLE_PWD=$DB_ADMIN_PASSWORD \
            -e ENABLE_ARCHIVELOG=$LOGGING_DB_ENABLE_ARCHIVELOG \
            -e ENABLE_FORCE_LOGGING=$LOGGING_ENABLE_FORCE_LOGGING \
            -e ORACLE_SID=$DB_SID \
            -e ORACLE_PWD=$DB_ADMIN_PASSWORD \
            $IMAGE_NAME
    fi
else
    # oracle docker instance does NOT exist
    echo "Docker image $IMAGE_NAME not found. Please follow the steps in docs/init_database.md to initialize the database."
    echo
    cat $DOCS/init_database.md
    echo
fi

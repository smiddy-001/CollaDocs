#!/bin/bash

# Usage: config/load_config.sh --config <config_file> --mode <mode>
#   --config: Path to the YAML configuration file
#   --mode: Configuration mode (e.g., dev, test)


# Function to parse YAML
function parse_yaml {
    local prefix=$2
    local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
    sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" "$1" |
    awk -F$fs '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            # Remove inline comments and trim
            value=$3
            sub(/#.*$/, "", value)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
            gsub(/"/, "", value) # Remove quotes around the value
            printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, value);
        }
    }'
}

# Function to print usage
usage() {
    echo "Usage: $0 --config <config_file> --mode <mode>"
    echo "  --config: Path to the YAML configuration file"
    echo "  --mode: Configuration mode (e.g., dev, test)"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --config) CONFIG_FILE="$2"; shift ;;
        --mode) MODE="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

# Check if required arguments are provided
if [ -z "$CONFIG_FILE" ] || [ -z "$MODE" ]; then
    usage
fi

# Check if the mode is 'default'
if [ "$MODE" = "default" ]; then
    echo "Error: 'default' cannot be used as a mode."
    exit 1
fi

# Function to set and export variables
set_and_export_variables() {
    local section=$1
    local temp_file=$(mktemp)  # Create a temporary file

    # Run parse_yaml and store the result in the temp file
    parse_yaml "$CONFIG_FILE" > "$temp_file"

    # Read the temp file line by line
    while IFS='=' read -r key value; do
        if [[ $key == ${section}* ]]; then
            new_key=${key#${section}_}  # Remove the section prefix from the key
            if [[ ! "$new_key" =~ ^(MODE|CONFIG_FILE)$ ]]; then
                # Export the key-value pair as an environment variable
                eval "export $new_key=\"$value\""
            fi
        fi
    done < "$temp_file"

    # Clean up the temporary file
    rm -f "$temp_file"
}


# Set and export variables for the default configuration
set_and_export_variables "default"

# Set and export variables for the specified mode, overriding defaults if present
set_and_export_variables "$MODE"

# Function to print exported variables
print_exported_variables() {
    for var in $(compgen -e); do
        if [[ ! "$var" =~ ^(MODE|CONFIG_FILE)$ ]]; then
            echo "$var=${!var}"
        fi
    done
}

# Check if the script is being sourced or executed
(return 0 2>/dev/null) && sourced=1 || sourced=0

if [ $sourced -eq 1 ]; then
    echo "Environment variables for $MODE have been exported to the current shell."
    echo "Exported variables:"
    print_exported_variables
else
    echo "Variables that would be exported:"
    print_exported_variables
    echo
    echo "To add these variables to your environment, run:"
    echo "source $(readlink -f "$0") --config \"$CONFIG_FILE\" --mode \"$MODE\""
    echo
fi

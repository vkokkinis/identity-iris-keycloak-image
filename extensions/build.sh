#!/bin/bash

# SPDX-FileCopyrightText: 2025 Deutsche Telekom AG
#
# SPDX-License-Identifier: Apache-2.0

LIBS_DIR="./../providers"
KEYCLOAK_VERSION="$1"
if [ -z "$KEYCLOAK_VERSION"  ]; then
        echo "Keycloak version not specified"
	exit 1
fi

function init() {
  mkdir -p "$LIBS_DIR"
}


function build_keycloak_extension() {
  EXTENSION_NAME="$1"

  echo "Building $EXTENSION_NAME for Keycloak version $KEYCLOAK_VERSION"
  
  # Check if the directory exists before running the gradle build
  if [ ! -d "$EXTENSION_NAME" ]; then
    echo "Error: Extension directory '$EXTENSION_NAME' does not exist."
    exit 1
  fi
  
  # Display the current directory to ensure the script is running in the correct place
  echo "Current directory: $(pwd)"
  
  # List the contents of the directory to make sure the gradle wrapper is present
  echo "Listing directory contents of $EXTENSION_NAME:"
  ls -l "$EXTENSION_NAME"
  
  # Run the gradle build with debug logging enabled
  echo "Running Gradle build for $EXTENSION_NAME with Keycloak version $KEYCLOAK_VERSION"
  ./gradlew clean build --no-daemon -p ./$EXTENSION_NAME -PkeycloakVersion="$KEYCLOAK_VERSION" --stacktrace --info > build_output.log 2>&1
  
  # Check if the gradle build was successful
  if [ $? -eq 0 ]; then
    echo "Build successful for $EXTENSION_NAME"
    
    # Copy build files to LIBS_DIR
    echo "Copying build output to $LIBS_DIR/"
    cp -a "$EXTENSION_NAME/build/libs/." "$LIBS_DIR/"
    return 0
  else
    echo "Build failed for $EXTENSION_NAME. Check the logs below:"
    
    # Output the contents of the log to debug further
    cat build_output.log
    exit 1
  fi
}


init && \
build_keycloak_extension keycloak-metrics-spi

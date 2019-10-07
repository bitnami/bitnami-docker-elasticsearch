#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libos.sh
. /libfs.sh
. /libelasticsearch.sh

# Load Elasticsearch environment variables
eval "$(elasticsearch_env)"

# Ensure kernel settings are valid
elasticsearch_validate_kernel
# Ensure Elasticsearch environment variables settings are valid
elasticsearch_validate
# Ensure Elasticsearch is stopped when this script ends
trap "elasticsearch_stop" EXIT
# Ensure Elasticsearch is initialized
elasticsearch_initialize
# Install Elasticsearch plugins
if [[ -n "$ELASTICSEARCH_PLUGINS" ]]; then
    elasticsearch_install_plugins
fi

if [[ -n "$ELASTICSEARCH_KEYS" ]]; then
    elasticsearch_add_keys
fi
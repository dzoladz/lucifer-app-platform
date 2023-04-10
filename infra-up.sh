# -----------------------------
# SET THE FOLLOWING VARIABLES
DIR_PATH=$PWD
# -----------------------------

# ---------------------
# ESTABLISH NETWORKING
# order matters
# ---------------------

# Global Network - Gateway
docker network create --driver=bridge --attachable --internal=false gateway

# Build Traefik - Traffic Router
cd ${DIR_PATH}/traefik
docker-compose -f docker-compose.yml up -d

# Build Portainer - Container Management Tools
cd ${DIR_PATH}/portainer
docker-compose -f docker-compose.yml up -d

# ----------------------------------------------------------
# HOSTED APPLICATIONS
# order doesn't matter... connecting to the gateway network
# ----------------------------------------------------------

# Build Grafana
cd ${DIR_PATH}/grafana
docker-compose -f docker-compose.yml up -d

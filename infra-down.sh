# -----------------------------
# SET THE FOLLOWING VARIABLES
DIR_PATH=$PWD
# -----------------------------

# ----------------------------------------------------------
# MAIN INFRASTRUCTURE
# ----------------------------------------------------------

# Build Traefik - Traffic Router
cd ${DIR_PATH}/traefik
docker-compose -f docker-compose.yml down

# Build Portainer - Container Management Tools
cd ${DIR_PATH}/portainer
docker-compose -f docker-compose.yml down


# ----------------------------------------------------------
# HOSTED APPLICATIONS
# ----------------------------------------------------------

# Weeding Helper
# cd ${DIR_PATH}/weeding-helper/docker
# docker-compose -f docker-compose.yml down


# ----------------------------------------------------------
# REMOVE NETWORK
# ----------------------------------------------------------

# Global Network - Gateway
docker network rm gateway
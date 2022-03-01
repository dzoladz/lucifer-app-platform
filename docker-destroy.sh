docker stop $(docker ps -a -q)
sleep 1

docker rm $(docker ps -a -q)
sleep 1

docker network rm $(docker network ls -q)
sleep 1

docker rmi $(docker image ls -q)
sleep 1

docker volume rm $(docker volume ls -q)

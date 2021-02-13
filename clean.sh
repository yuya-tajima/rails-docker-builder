#!/usr/bin/env zsh

exec 3>&2
exec 2>&-
rm -rf rails/*
rm -rf rails/.*
rm -rf tmp/*
rm -rf tmp/.*
exec 2>&3
exec 3>&-

docker-compose down --rmi all --volumes --remove-orphans 2> /dev/null
docker image prune -f 2> /dev/null

echo
docker system df
echo
docker images -a
echo
docker container ls -a
echo
docker volume ls
echo
docker network ls

echo
echo "#################################################"
echo "#                                               #"
echo "# Cleanup process is finished!                  #"
echo "#                                               #"
echo "# If you need to remove docker resources above, #"
echo "# run the following commands.                   #"
echo "#                                               #"
echo "# 'docker image rm <IMAGE ID>' or prune         #"
echo "# 'docker container rm <CONTAINER ID>' or prune #"
echo "# 'docker volume rm <VOLUME NAME>' or prune     #"
echo "# 'docker network rm <NETWORK ID>' or prune     #"
echo "#                                               #"
echo "#################################################"
echo

rm Dockerfile 2> /dev/null
rm docker-compose.yml 2> /dev/null


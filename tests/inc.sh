
function check200 () {
  curl http://localhost:3000 -o /dev/null -w '%{http_code}\n' -s
}

docker-compose up -d

TRY_COUNT=0;
while :
do
  sleep 10
  if docker-compose run web rake db:create ; then
    break;
  fi
  echo
  echo 'Please wait a moment. The database may not be ready for connection...'
  TRY_COUNT=$((TRY_COUNT+1));
  if [[ $TRY_COUNT -eq 3 ]]; then
    echo "Case1 NG"
    return 1
  fi
done

echo "Case1 OK!"

CODE=$(check200)

echo
echo "Note: maybe you can now access http://localhost:3000"
echo
sleep 10

if [[ $CODE -eq 200 ]]; then
  echo "Case2 OK!"
else
  echo "Case2 NG! $CODE"
  return 1
fi

docker-compose stop
docker-compose up -d

sleep 10
CODE=$(check200)
if [[ $CODE -eq 200 ]]; then
  echo "Case3 OK!"
else
  echo "Case3 NG! $CODE"
  return 1
fi

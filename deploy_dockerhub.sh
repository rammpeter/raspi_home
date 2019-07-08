# create Docker image and deploy to dockerhub
# Peter Ramm, 08.07.2019
# execute from project root

(cd log && rm *.log)
(cd public/assets && rm *)
(cd tmp/cache/assets && rm -r *)

# Ensure using latest version
docker pull ruby:2.6.3

docker build -t rammpeter/raspi_home .

# Check active login at dockerhub
grep "https://index.docker.io/v1/" ~/.docker/config.json >/dev/null
if [ $? -ne 0 ]; then
  echo "########## You are not logged in to dockerhub! Please login before ##########"
  exit 1
fi

docker push rammpeter/raspi_home:latest

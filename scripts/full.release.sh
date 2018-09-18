if [[ $PRIVATE_IP == "" ]]
then
  echo "NO PRIVATE IP NO PARTY" && exit 1
fi

if [[ -d smache_rel ]]
then
  echo "DELETING PREVIOUS RELEASE" \
    && rm -rf smache_rel
fi

if [[ $CI_PIPELINE_IID == "" ]]
then
  ./scripts/secret.sh
fi

if [[ $VERSION == "" ]]
then
  VERSION=0.0.1
fi

if [[ $UPLINK_IP == "" ]]
then
  echo "No known node to deploy to"
else
  echo "export MIX_ENV=prod" >> .env \
    && echo "export APP=smache" >> .env \
    && echo "export VERSION=$VERSION" >> .env \
    && source .env \
    && docker-compose -f docker-compose.erl.release.yml up --build \
    && ./scripts/docker.copy.release.sh \
    && cp -R .env smache_rel \
    && cp -R rel smache_rel \
    && mv smache_rel/$VERSION/smache.tar.gz smache_rel \
    && rm -rf smache_rel/$VERSION

  UPLINK_NODE=smache@$PRIVATE_IP

  echo "export UPLINK_NODE=$UPLINK_NODE" >> smache_rel/.env
  echo "export PORT=4000" >> smache_rel/.env

  scp -r ./smache_rel groot@$UPLINK_IP:/home/groot \
    && ssh groot@$UPLINK_IP -y "bash -s" < ./scripts/full.boot.sh
fi

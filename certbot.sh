#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

docker pull certbot/certbot

rm -rf /tmp/certbot 2>/dev/null
mkdir -p /tmp/certbot "${DIR}/haproxy/certs" 2>/dev/null
chmod 777 /tmp/certbot -R 2>/dev/null

docker run --rm \
  --name="certbot-standalone" \
  --hostname="certbot-standalone" \
  --net="vncert_certbot_private" \
  -v "/tmp/certbot:/etc/letsencrypt/archive:rw" \
  certbot/certbot certonly --non-interactive --agree-tos --email dtvinh@vncert.vn --standalone \
  -d vncert.vn -d vncert.gov.vn -d www.vncert.vn -d www.vncert.gov.vn
  # "${hostnames[i]}"

# hostnames=(vncert.vn vncert.gov.vn www.vncert.vn www.vncert.gov.vn)
hostnames=(vncert.vn)
for i in "${!hostnames[@]}"; do
  domain="${hostnames[i]}"
  echo 'Certbot for '"${domain}"
  cat "/tmp/certbot/${domain}/fullchain1.pem" "/tmp/certbot/${domain}/privkey1.pem" > "${DIR}/haproxy/certs/${domain}.pem"
  rm -rf "/tmp/certbot/${domain}"
done

docker kill haproxy
docker start haproxy

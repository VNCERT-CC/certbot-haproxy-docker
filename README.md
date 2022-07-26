# certbot-haproxy-docker
Auto cerbot with haproxy on docker

# Haproxy configuration
```
frontend http-in
    bind *:80
    # bind *:443 ssl crt /tmp/certs/vncert-http.pem crt /tmp/certs/vncert-dns.pem
    mode http
    acl is_certbot path_beg /.well-known/acme-challenge
    use_backend to_bridge_certbot if is_certbot

backend to_bridge_certbot
    mode http
    server bridge_certbot unix@/opt/run/bridge_certbot/http.sock check fall 2 inter 1s
```

# Generate certs
```
./bridge-haproxy-certbot.sh
sudo ./certbot.sh
```

# Crontab
```
sudo crontab -e
```

```
0 0 1 * * bash /path/to/certbot.sh > /tmp/certbot.log 2>&1
```

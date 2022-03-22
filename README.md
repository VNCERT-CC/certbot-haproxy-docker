# certbot-haproxy-docker
Auto cerbot with haproxy on docker

# Haproxy configuration
```
frontend http-in
    bind *:80
    mode http
    acl is_certbot path_beg /.well-known/acme-challenge
    use_backend to_vncert_certbot if is_certbot

backend to_vncert_certbot
    mode http
    server vncert_certbot unix@/opt/run/vncert_certbot/http.sock check fall 2 inter 1s
```

# Generate certs
```
sudo ./certbot.sh
```

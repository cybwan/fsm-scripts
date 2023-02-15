#!/bin/bash

set -uo pipefail

sudo hostnamectl set-hostname registry

cat >> /etc/hosts <<EOF
127.0.0.1 registry
127.0.0.1 local.registry
EOF

sudo systemctl disable --now swap.img.swap
sudo systemctl mask swap.target

sudo apt -y update

sudo apt install -y chrony bash-completion curl gnupg2 software-properties-common apt-transport-https ca-certificates

sudo chronyc sources -v
sudo timedatectl set-timezone Asia/Shanghai

cat >> ~/.bashrc <<EOF
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
#Enabling tab-completion
complete -cf sudo
complete -cf man
EOF


sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt -y update
sudo apt -y remove docker docker-engine docker.io containerd runc

sudo apt -y install ca-certificates curl gnupg lsb-release
sudo apt -y install docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo gpasswd -a $USER docker
sudo systemctl restart docker
sudo newgrp docker &

sudo tee /etc/modprobe.d/nf_conntrack.conf <<-'EOF'
#hashsize=nf_conntrack_max/8
options nf_conntrack hashsize=16384
EOF

sudo apt -y install nginx docker-compose-plugin jq

mkdir -p /opt/docker-registry/data
cd /opt/docker-registry

sudo tee docker-compose.yml <<EOF
version: '3'
services:
  registry:
    restart: always
    image: registry:latest
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - /opt/docker-registry/data:/data
EOF

sudo docker compose -f /opt/docker-registry/docker-compose.yml up -d

sudo openssl req -x509 -newkey rsa:4096 -nodes -sha256 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -days 3650 -subj '/CN=local.registry' -addext 'subjectAltName=DNS:local.registry'

sudo sed -i '/types_hash_max_size 2048;/a\\tclient_max_body_size 16384m;' /etc/nginx/nginx.conf

sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen 443 ssl default_server;
    include snippets/snakeoil.conf;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    server_name _;
    location / {
        # Do not allow connections from docker 1.5 and earlier
        # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
        if (\$http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {
            return 404;
        }

        proxy_pass                          http://localhost:5000;
        proxy_set_header  Host              \$http_host;   # required for docker client's sake
        proxy_set_header  X-Real-IP         \$remote_addr; # pass on real client's IP
        proxy_set_header  X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header  X-Forwarded-Proto \$scheme;
        proxy_read_timeout                  900;
    }
}
EOF

sudo systemctl restart nginx

curl -s http://local.registry/v2/_catalog | jq

sudo apt -y install openconnect
sudo tee /usr/local/bin/oc <<EOF
#!/bin/bash
sudo ip r add 0.0.0.0/0 via 192.168.127.1
sleep 2
echo ${OCPAWD} | openconnect ${SERVER_ADDR} --servercert ${SERVER_CERT} -u ${OCUSER} --passwd-on-stdin
EOF
sudo chmod a+x /usr/local/bin/oc

sudo tee /usr/local/bin/nat <<EOF
#!/bin/bash
sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
sudo iptables -A FORWARD -i ens33 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ens36 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ens33 -o tun0 -j ACCEPT
sudo iptables -A FORWARD -i ens36 -o tun0 -j ACCEPT
EOF
sudo chmod a+x /usr/local/bin/nat

sudo apt -y upgrade
sudo apt -y autoclean
sudo apt -y autoremove

sudo systemctl reboot
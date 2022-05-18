#!/usr/bin/env bash

#bash <(curl -Ls https://raw.githubusercontent.com/54shady/git-usage/master/deploy.sh)

apt update -y && apt install -y curl socat
curl https://get.acme.sh | sh -s email=zeroway5405@qq.com
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
MDN="vps.zeroway.xyz"
~/.acme.sh/acme.sh --issue -d $MDN --standalone
~/.acme.sh/acme.sh --installcert -d $MDN --key-file /root/private.key --fullchain-file /root/cert.crt
bash <(curl -Ls https://raw.githubusercontent.com/54shady/git_usage/master/install.sh)
iptables -I INPUT -p tcp --dport 8888 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT

# install caddy
echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
	    | tee -a /etc/apt/sources.list.d/caddy-fury.list
apt update && apt install -y caddy
curl -o /usr/bin/caddy "https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fmastercactapus%2Fcaddy2-proxyprotocol&idempotency=79074247675458"
chmod +x /usr/bin/caddy
systemctl stop caddy
curl -Ls https://raw.githubusercontent.com/54shady/mygentoo/master/vps/Caddyfile -o /etc/caddy/Caddyfile
systemctl start caddy
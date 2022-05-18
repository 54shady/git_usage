#!/usr/bin/env bash

apt update -y && apt install -y curl socat
curl https://get.acme.sh | sh -s email=zeroway5405@qq.com
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
MDN="vps.zeroway.xyz"
~/.acme.sh/acme.sh --issue -d $MDN --standalone
~/.acme.sh/acme.sh --installcert -d $MDN --key-file /root/private.key --fullchain-file /root/cert.crt
bash <(curl -Ls https://raw.githubusercontent.com/54shady/git-usage/master/install.sh)
iptables -I INPUT -p tcp --dport 8888 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT

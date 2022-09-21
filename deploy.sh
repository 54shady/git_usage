#!/usr/bin/env bash

# this script work for debian 10
#bash <(curl -Ls https://raw.githubusercontent.com/54shady/git_usage/master/deploy.sh vps.name.com)

apt update -y && apt install -y curl socat
curl https://get.acme.sh | sh -s email=zeroway5405@qq.com
iptables -I INPUT -p tcp --dport 80 -j ACCEPT

# My DND Name: for example vps.name.xyz
MDN="$1"
~/.acme.sh/acme.sh --issue -d $MDN --standalone
~/.acme.sh/acme.sh --installcert -d $MDN --key-file /root/private.key --fullchain-file /root/cert.crt
#bash <(curl -Ls https://raw.githubusercontent.com/54shady/git_usage/master/install.sh)
mkdir -p /usr/local/bin

# https://github.com/XTLS/Xray-core/releases/tag/v1.5.5
DOWNLOAD_PATH="https://raw.githubusercontent.com/54shady/git_usage/master"
curl -Ls $DOWNLOAD_PATH/xray -o /usr/local/bin/xray
chmod +x /usr/local/bin/xray
curl -Ls $DOWNLOAD_PATH/geoip.dat -o /usr/local/bin/geoip.dat
curl -Ls $DOWNLOAD_PATH/geosite.dat -o /usr/local/bin/geosite.dat
curl -Ls $DOWNLOAD_PATH/config.json -o /usr/local/bin/config.json
curl -Ls $DOWNLOAD_PATH/trojan.json -o /usr/local/bin/trojan.json
/usr/local/bin/xray -c /usr/local/bin/trojan.json &

# no need for 8888 port open
#iptables -I INPUT -p tcp --dport 8888 -j ACCEPT

iptables -I INPUT -p tcp --dport 443 -j ACCEPT

# install caddy
mkdir -p /var/www/html
cat > /var/www/html/index.html << EOF
<h1>Hello Sara</h1>
EOF

#curl -Ls https://raw.githubusercontent.com/54shady/git_usage/master/caddy.service -o /lib/systemd/system/caddy.service
#ln -s /lib/systemd/system/caddy.service /etc/systemd/system/multi-user.target.wants/caddy.service

#echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
#	    | tee -a /etc/apt/sources.list.d/caddy-fury.list
#apt update && apt install -y caddy
#systemctl stop caddy
#rm -rf /usr/bin/caddy

curl -Ls $DOWNLOAD_PATH/caddy -o /usr/bin/caddy
chmod +x /usr/bin/caddy
mkdir /etc/caddy
MYGTVPS="https://raw.githubusercontent.com/54shady/mygentoo/master/vps"
curl -Ls $MYGTVPS/Caddyfile -o /etc/caddy/Caddyfile
/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile &

# add a auto start script
curl -Ls $DOWNLOAD_PATH/rc.local -o /etc/rc.local
chmod +x /etc/rc.local
ln -s /lib/systemd/system/rc.local.service /etc/systemd/system/

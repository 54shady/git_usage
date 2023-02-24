#!/usr/bin/env bash
set -x

# this script work for debian 10
#bash <(curl -Ls https://raw.githubusercontent.com/54shady/git_usage/master/deploy.sh) gpt.yieyu.xyz

# Basic setup
apt update -y && apt install -y curl socat
curl https://get.acme.sh | sh -s email=fakename@mail.com

# Ports Configuration
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
# what if you wanna change port to something else
# for example, 1443, change the iptables config and
# trojan.json file
iptables -I INPUT -p tcp --dport 443 -j ACCEPT

# Fetch my domain name form first argument
DOMAINAME="$1"
~/.acme.sh/acme.sh --force --issue -d $DOMAINAME --standalone --server LetsEncrypt.org
~/.acme.sh/acme.sh --installcert -d $DOMAINAME --key-file /root/private.key --fullchain-file /root/cert.crt

#bash <(curl -Ls https://raw.githubusercontent.com/54shady/git_usage/master/install.sh)
mkdir -p /usr/local/bin

# https://github.com/XTLS/Xray-core/releases/tag/v1.5.5
SCRIPT_REPO="https://raw.githubusercontent.com/54shady/git_usage/master"
curl -Ls $SCRIPT_REPO/xray -o /usr/local/bin/xray
chmod +x /usr/local/bin/xray
curl -Ls $SCRIPT_REPO/geoip.dat -o /usr/local/bin/geoip.dat
curl -Ls $SCRIPT_REPO/geosite.dat -o /usr/local/bin/geosite.dat
curl -Ls $SCRIPT_REPO/config.json -o /usr/local/bin/config.json
curl -Ls $SCRIPT_REPO/trojan.json -o /usr/local/bin/trojan.json

# Do rename stub domain name to new assign name
sed -i "s/www.stub.com/$DOMAINAME/" /usr/local/bin/trojan.json

# Run the xray
/usr/local/bin/xray -c /usr/local/bin/trojan.json &

# Caddy Setup
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

curl -Ls $SCRIPT_REPO/caddy -o /usr/bin/caddy
chmod +x /usr/bin/caddy
mkdir /etc/caddy
curl -Ls $SCRIPT_REPO/Caddyfile -o /etc/caddy/Caddyfile
sed -i "s/www.stub.com/$DOMAINAME/" /etc/caddy/Caddyfile
/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile &

# add a auto start script
curl -Ls $SCRIPT_REPO/rc.local -o /etc/rc.local
chmod +x /etc/rc.local
ln -s /lib/systemd/system/rc.local.service /etc/systemd/system/

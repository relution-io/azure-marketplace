#!/bin/bash

# Usage
# sh script.sh --orga_name test --db_type mssql --db_host my.host.com --db_port 1433 --db_name relution --db_user relution --db_password s3cret
#
# output is in less /var/lib/waagent/Microsoft.OSTCExtensions.CustomScriptForLinux-1.5.2.0/download/0/stdout
#

while [[ $# > 1 ]]
do
key="$1"

case $key in
    --orga_name)
    ORGA_NAME="$2"
    shift # past argument
    ;;
    --db_type)
    DB_TYPE="$2"
    shift # past argument
    ;;
    --db_host)
    DB_HOST="$2"
    shift # past argument
    ;;
    --db_port)
    DB_PORT="$2"
    shift # past argument
    ;;
    --db_name)
    DB_NAME="$2"
    shift # past argument
    ;;
    --db_user)
    DB_USER="$2"
    shift # past argument
    ;;
    --db_password)
    DB_PASSWORD="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

echo "  _____      _       _   _             "
echo " |  __ \    | |     | | (_)            "
echo " | |__) |___| |_   _| |_ _  ___  _ __  "
echo " |  _  // _ \ | | | | __| |/ _ \| '_ \ "
echo " | | \ \  __/ | |_| | |_| | (_) | | | |"
echo " |_|  \_\___|_|\__,_|\__|_|\___/|_| |_|"
echo ""
echo ORGA_NAME   = "${ORGA_NAME}"
echo DB_TYPE     = "${DB_TYPE}"
echo DB_HOST     = "${DB_HOST}"
echo DB_PORT     = "${DB_PORT}"
echo DB_NAME     = "${DB_NAME}"
echo DB_USER     = "${DB_USER}"


# permit root login and add default ssh keys
sed -i 's/PermitRootLogin forced-commands-only/PermitRootLogin yes/g' /etc/ssh/sshd_config
/sbin/service sshd restart

mkdir /root/.ssh
cat > /root/.ssh/authorized_keys << "EOF"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDRRhNDE2yOTQbDJQgtphL+BFYSTJEfA5/wXmYfiFClB0neuYyvZgiyRBLcyrnHN+Am34L1ne+4UklDLN7AqNDdJSnHXfBVN6sIw59bSHcNlgivNm1U4EHwJry/pBsknk3Q8JDMUTp9UjZTX2j44utF92YrAHa4rCBSTYbt0cxY1fOFrHsAuZEK+rJnuelmxmcpAoscSArdKKNe7HfgpPXZ90ZWQmeAk2LlMm9kQ9NY1lm2u/hV+rUgbWgDyMm2bsWMs3EZe8g2H5vgbCaCjnqbUXUs/3hehiPzzQKYTlZeCkRu5ro1FxMKow5AaPNZrr5B/6KveAAbCyvRIP4EmTj xxx@mwaysolutions.com
EOF

# aliases
cat >> /root/.bashrc << "EOF"
alias l='ls -lah'
alias ..='cd ..'
alias psa='ps --ppid 2 -p 2 --deselect f -o pid,user,%cpu,%mem,tname,start,time,cmd'
EOF

# set some kernel options and activate them
cat >> /etc/sysctl.conf << "EOF"
# Allow more open files (sockets are also files) cat /proc/sys/fs/file-nr (default: 58426)
fs.file-max = 294180
# Do not send TCP timestamps --> Attackers can derive the last system reboot and hence the max kernel update
net.ipv4.tcp_timestamps=0
# Avoid a smurf attack,  ignore ICMP messages to broadcast or multicast addresses (default: 1)
net.ipv4.icmp_echo_ignore_broadcasts = 1 
# Turn on protection for bad icmp error messages (default: 1)
net.ipv4.icmp_ignore_bogus_error_responses = 1 
# Turn on and log spoofed, source routed, and redirect packets (default: 0)
net.ipv4.conf.all.log_martians = 1 
net.ipv4.conf.default.log_martians = 1
# Do not accept source routing (default: 0)
net.ipv4.conf.all.accept_source_route = 0 
net.ipv4.conf.default.accept_source_route = 0
# Make sure no one can alter the routing tables (default: 1)
net.ipv4.conf.all.accept_redirects = 0 
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
# Don't act as a router, except im a nat instance (default: 1 1)
net.ipv4.conf.all.send_redirects = 0 
net.ipv4.conf.default.send_redirects = 0
# Turn on execshild (default: ? ? 2)
kernel.randomize_va_space = 2 
#Deactivate IPv6
net.ipv6.conf.all.disable_ipv6 = 1 
net.ipv6.conf.default.disable_ipv6 = 1
EOF
# reload sysctl settings
sysctl -p /etc/sysctl.conf

# disable scatter/gather to prevent "xen_netfront: xennet: skb rides the rocket:"
ethtool -K eth0 sg off

# iptables off
service iptables stop
service ip6tables stop

# set timezone
echo "cp -f /usr/share/zoneinfo/Europe/Berlin /etc/localtime" >> /etc/rc.local

# install additional default packages
yum clean all
yum -y install epel-release 
yum -y install vim wget tcpdump ntpdate telnet nginx java-1.8.0-openjdk-devel unzip

export DNS_HOST=relution-$ORGA_NAME
export DNS_DOMAIN=azure.mway.io
#curl https://raw.githubusercontent.com/taimos/route53-updater/v1.5/cloud-init/ec2-public.sh | bash

hostname $DNS_HOST.$DNS_DOMAIN
cat > /etc/hosts << HOSTS
127.0.0.1  localhost
$PRIVATE_IP $DNS_HOST.$DNS_DOMAIN $DNS_HOST
HOSTS

# Restart syslog to reload hostname
service rsyslog restart

# TODO: server cert
mkdir -p /etc/nginx/errors
wget -O /etc/nginx/server.key http://dl.aws.mway.io/E01B9747-7CB8-4465-B2DE-F65AC97E52C8/relution.key 
wget -O /etc/nginx/server.pem http://dl.aws.mway.io/254F761D-2036-4984-9A67-D910AABF0A2C/relution.pem
wget -O /etc/nginx/dhparams.pem http://dl.aws.mway.io/80F9B7B7-EB07-4BB5-8C62-237985F01D5D/dhparams.pem
wget -O /etc/nginx/errors/502.html http://dl.aws.mway.io/CC537348-5E70-4139-B2B6-EABAF3537C87/502.html

cat > /etc/nginx/nginx.conf << "EOF"
user  nginx;
worker_processes  1;
#error_log  syslog:server=localhost warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    # increase request size for app upload
    client_max_body_size 1024M;
    large_client_header_buffers 8 32k;
    log_format main '$remote_addr - $remote_user [$time_local] '
                '"$request" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent” "$http_x_forwarded_for" '
                '$request_time $upstream_response_time $pipe';
    #access_log  syslog:server=localhost  main;
    sendfile        on;
    keepalive_timeout  65;
    index   index.html index.htm;

    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

    server {
        listen 80 default_server;
        # Redirect to HTTPS
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;

        ssl_certificate      /etc/nginx/server.pem;
        ssl_certificate_key  /etc/nginx/server.key;
        ssl_prefer_server_ciphers   on;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
        ssl_dhparam /etc/nginx/dhparams.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

        location ~ /.well-known {
            allow all;
        }

        location / {
            gzip on;
            gzip_proxied any;
            gzip_min_length  1100;
            gzip_buffers 4 32k;
            gzip_types text/plain application/javascript text/xml text/css;
            gzip_vary on;

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_pass http://127.0.0.1:8080;
            proxy_read_timeout 90;
            #proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
        }

        error_page 502 /502.html;
        error_page 503 /502.html;
        error_page 504 /502.html;
        location /502.html {
            root /etc/nginx/errors;
        }
    }
}

EOF

# install relution
useradd -d /opt/relution relution

# disable selinux
setenforce 0
echo 0 > /selinux/enforce
# TODO
cat > /etc/selinux/config << EOF
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#     targeted - Targeted processes are protected,
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted 
EOF

#start nginx
service nginx restart

## TODO
#certificate with lets encrypt
#wget https://dl.eff.org/certbot-auto
#chmod a+x certbot-auto
#sh certbot-auto certonly --staging -a webroot --webroot-path=/usr/share/ngnix/html/ -d $DNS_HOST.$DNS_DOMAIN

#link certs to certificate folder
#rm -rf /etc/nginx/server.pem
#rm -rf /etc/nginx/server.key
#ln -s /etc/letsencrpt/live/$DNS_HOST.$DNS_DOMAIN/privkey.pem /etc/nginx/server.key 
#ln -s /etc/letsencrpt/live/$DNS_HOST.$DNS_DOMAIN/fullchain.pem /etc/nginx/server.pem 

#reload nginx
#service nginx reload

export JAVA_HOME=/usr/lib/jvm/java-1.8.0

wget http://repo.relution.io/package/latest/relution-package.zip -O /opt/relution.zip

cd /opt
unzip relution.zip

# configure database connections
cat > /opt/relution/conf/sql.conf << EOF
database.type=$DB_TYPE
database.host=$DB_HOST
database.port=$DB_PORT
database.name=$DB_NAME
database.user=$DB_USER
database.password=$DB_PASSWORD
EOF

cat > /opt/relution/bootstrap-properties/appender.properties << "EOF"
syslog.enabled=true
EOF

cat > /opt/relution/bootstrap-properties/logger.properties << "EOF"
syslog.enabled=true
EOF

cat > /opt/relution/bootstrap-properties/http.properties << "EOF"
http.port=8080
http.forwarded=true
EOF

# start relution
chown -R relution:relution /opt/relution
echo "Starting Relution ...."
su -c "/opt/relution/bin/relution.sh start" relution
echo "Relution started!"
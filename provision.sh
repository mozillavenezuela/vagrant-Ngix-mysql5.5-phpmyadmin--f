#!/usr/bin/env bash
#export DEBIAN_FRONTEND=noninteractive

PASSWORD='root'
aptitude update -y > /dev/null 2>&1
aptitude install nginx nginx-common php5-fpm -y

debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD" > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"  > /dev/null 2>&1

aptitude install mysql-server php5-mysql php5-mcrypt php5-cli php5-curl php5-gd  php5-imagick -y  > /dev/null 2>&1

rm /etc/nginx/sites-available/default
touch /etc/nginx/sites-available/default

cat >> /etc/nginx/sites-available/default <<'EOF'
server {
    listen   80;
    root /usr/share/nginx/html;
    index index.php index.html index.htm;
    # Make site accessible from http://localhost/
    server_name _;
    location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to index.html
        try_files $uri $uri/ /index.html;
    }
    location /doc/ {
        alias /usr/share/doc/;
        autoindex on;
        allow 127.0.0.1;
        deny all;
    }
    # redirect server error pages to the static page /50x.html
    #
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
    # pass the PHP scripts to FastCGI server listening on the php-fpm socket
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny all;
    }
}
EOF
service nginx restart


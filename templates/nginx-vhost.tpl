server {
    listen 80;
    client_max_body_size 20M;
 
    server_name %DOMAIN%;
    root /home/%USERNAME%/%PROJECT%/%ENV%/current/web;
 
    error_log /var/log/nginx/%USERNAME%_%PROJECT%_%ENV%.error.log;
    # access_log /var/log/nginx/%USERNAME%_%PROJECT%_%ENV%.access.log;
 
    # strip %FRONTCONTROLLER%.php/ prefix if it is present
    rewrite ^/%FRONTCONTROLLER%\.php/?(.*)$ /$1 permanent;
 
    location = /favicon.ico {
        access_log     off;
        log_not_found  off;
    }
 
    location = /robots.txt {
        allow all;
        access_log     off;
        log_not_found  off;
    }
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires        max;
        add_header     Pragma public;
        add_header     Cache-Control "public, must-revalidate, proxy-revalidate";
        access_log     off;
        log_not_found  off;
    }
 
    location / {
        index %FRONTCONTROLLER%.php;
        try_files $uri @rewriteapp;
    }
 
    location @rewriteapp {
        rewrite ^(.*)$ /%FRONTCONTROLLER%.php/$1 last;
    }
 
    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    location ~ ^/%FRONTCONTROLLER%\.php(/|$) {
        fastcgi_split_path_info ^(.+\.php)(/.*)$;

        fastcgi_pass   unix:/tmp/php5-fpm-%USERNAME%.sock;
        fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param  HTTPS              off;
        include fastcgi_params;
    }
}

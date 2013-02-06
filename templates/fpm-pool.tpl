[%POOLNAME%]
listen = /tmp/php5-fpm-%POOLNAME%.sock

user = %POOLNAME%
group = %POOLNAME%

pm = dynamic
pm.max_children = 3
pm.start_servers = 1
pm.min_spare_servers = 1
pm.max_spare_servers = 1
pm.max_requests = 200

catch_workers_output = yes
#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

exit 0

cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/nginx
www-servers/nginx -* http http-cache http2 ipv6 nginx_modules_http_access nginx_modules_http_auth_basic nginx_modules_http_cache_purge nginx_modules_http_charset nginx_modules_http_gzip nginx_modules_http_headers_more nginx_modules_http_naxsi nginx_modules_http_proxy nginx_modules_http_realip nginx_modules_http_rewrite nginx_modules_http_sticky nginx_modules_http_upstream_check nginx_modules_http_upstream_keepalive nginx_modules_http_upstream_least_conn pcre ssl vim-syntax
EOF

chroot /mnt/gentoo /usr/bin/emerge www-servers/nginx

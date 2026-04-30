#!/bin/bash
set -eux

dnf update -y || yum update -y
dnf install -y httpd || yum install -y httpd

systemctl enable httpd
systemctl start httpd

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>IaC Homework</title>
  </head>
  <body>
    <h1>${web_message}</h1>
  </body>
</html>
EOF

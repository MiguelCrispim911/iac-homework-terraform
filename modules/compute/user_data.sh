#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>IaC Homework</title>
</head>
<body>
  <h1>Hi, I am ${owner} and this is my IaC</h1>
</body>
</html>
EOF
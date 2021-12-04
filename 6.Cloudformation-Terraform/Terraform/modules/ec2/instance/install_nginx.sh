#!/bin/bash
echo "-------------------START-------------------"
amazon-linux-extras install nginx1

mkdir -p /var/www/hellowebsite
echo "<html><body><center><h1>Hello from $HOSTNAME</h1></center></body></html>" > /var/www/hellowebsite/index.html

echo -e "server {\n\tlisten 80;\n\tlisten [::]:80;\n\troot /var/www/hellowebsite;\n\tindex index.html;\n\tlocation / {\n\t\ttry_files \$uri \$uri/ =404;\n\t}\n}" > /etc/nginx/conf.d/hello-website.conf

systemctl enable nginx
systemctl start nginx
echo "-------------------FINISH------------------"

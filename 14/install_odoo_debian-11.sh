#!/bin/sh

echo INSTALLING DEPENDENCIES
echo -----------------------
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y python3 python3-pip
sudo apt-get install -y git python3 python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev swig libsasl2-dev python3-setuptools node-less libjpeg-dev gdebi gcc
sudo apt-get install -y libpq-dev python-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libffi-dev libssl-dev
sudo pip3 install PyPDF2 Werkzeug==0.11.15 python-dateutil reportlab psycopg2-binary

echo INSTALLING NPM
echo -----------------------
sudo apt-get install -y npm
sudo npm install -g rtlcss
sudo npm install -g less less-plugin-clean-css
sudo apt-get install -y node-less

echo INSTALLING WKHTML2PDF
echo -----------------------
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6-1.buster_amd64.deb

echo INSTALLING POSTGRESQL
echo -----------------------
sudo adduser --system --home=/opt/odoo --group odoo
sudo apt-get install -y postgresql
sudo su postgres
echo CREATE ODOO DATABASE:
echo createuser --createdb --username postgres --no-createrole --no-superuser --pwprompt odoo
echo psql
echo ALTER USER odoo WITH SUPERUSER;
echo \q
echo exit

echo ODOO
echo -----------------------
cd /opt/odoo
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch 14.0 --single-branch .
sudo chown -R odoo:odoo /opt/odoo
cd /opt/odoo
sudo pip3 install -r requirements.txt

echo POST-INSTALLATION
echo -----------------------
sudo mkdir /var/log/odoo
sudo chown odoo:root /var/log/odoo

sudo cat <<EOF > /etc/odoo.conf
[options]
; This is the password that allows database operations:
; admin_passwd = admin
db_host = False
db_port = False
db_user = False
db_password = False
addons_path = /opt/odoo/addons
logfile = /var/log/odoo/odoo.log
EOF

sudo chown odoo: /etc/odoo.conf
sudo chmod 640 /etc/odoo.conf

echo ODOO SERVICE
echo -----------------------
sudo cat <<EOF > /etc/systemd/system/odoo.service
[Unit]
  Description=Odoo
  Documentation=http://www.odoo.com
  [Service]
  # Ubuntu/Debian convention:
  Type=simple
  User=odoo
  ExecStart=/opt/odoo/odoo-bin -c /etc/odoo.conf
  [Install]
  WantedBy=default.target
EOF

sudo chmod 755 /etc/systemd/system/odoo.service
sudo chown root: /etc/systemd/system/odoo.service
sudo systemctl start odoo.service
sudo systemctl enable odoo.service
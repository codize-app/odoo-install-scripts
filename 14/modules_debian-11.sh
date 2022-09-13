#!/bin/sh

echo GET MODULES FROM GIT
echo -----------------
cd /opt/odoo
sudo mkdir sources
cd sources
sudo git clone https://github.com/codize-app/odoo-argentina -b 14.0
sudo git clone https://github.com/OCA/reporting-engine -b 14.0
sudo git clone https://github.com/OCA/web -b 14.0
sudo git clone https://github.com/OCA/account-reconcile -b 14.0
sudo git clone https://github.com/ExemaxSAS/helpdesk_button -b 14.0
sudo git clone https://github.com/CybroOdoo/CybroAddons -b 14.0
sudo git clone https://github.com/odoomates/odooapps -b 14.0
sudo git clone https://github.com/codize-app/odoo-argentina-withholding -b 14.0

echo SETTINGS MODULES
echo -----------------
cd /opt/odoo/sources/odoo-argentina
sudo pip3 install -r requirements.txt
sudo apt-get install -y python3-m2crypto
cd ~
git clone https://github.com/pyar/pyafipws.git -b py3k
cd pyafipws
sudo python3 setup.py install
sudo sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf
cd /usr/local/lib/python3.9/dist-packages/pyafipws
sudo mkdir cache
sudo chmod -R 777 cache

echo ADDONS_PATH:
sudo sed -i 's/\/opt\/odoo\/addons/\/opt\/odoo\/addons, \/opt\/odoo\/sources, \/opt\/odoo\/sources\/web, \/opt\/odoo\/sources\/odoo-argentina, \/opt\/odoo\/sources\/odoo-argentina-withholding, \/opt\/odoo\/sources\/account-reconcile, \/opt\/odoo\/sources\/CybroAddons, \/opt\/odoo\/sources\/reporting-engine, \/opt\/odoo\/sources\/om_account_accountant/g' /etc/odoo.conf
echo /opt/odoo/sources, /opt/odoo/sources/odoo-argentina, /opt/odoo/sources/odoo-argentina-withholding, /opt/odoo/sources/account-reconcile, /opt/odoo/sources/CybroAddons, /opt/odoo/sources/reporting-engine, /opt/odoo/sources/om_account_accountant
echo RESTARTING ODOO SERVER
sudo service odoo restart

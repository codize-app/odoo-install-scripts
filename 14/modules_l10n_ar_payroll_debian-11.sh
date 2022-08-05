#!/bin/sh

echo GET MODULES FROM GIT
echo -----------------
cd /opt/odoo/sources
sudo git clone https://github.com/nimarosa/hr -b 14.0
sudo git clone https://github.com/OCA/hr-expense -b 14.0
sudo git clone https://github.com/OCA/hr-holidays -b 14.0
sudo git clone https://github.com/OCA/connector-telephony -b 14.0
sudo git clone https://github.com/OCA/payroll -b 14.0
sudo git clone https://github.com/nimarosa/odoo-l10n_ar_hr_payroll -b 14.0

echo SETTINGS MODULES
echo -----------------
cd /opt/odoo/sources/hr
sudo pip3 install -r requirements.txt
cd /opt/odoo/sources/connector-telephony
sudo pip3 install -r requirements.txt

echo ADDONS_PATH:
echo /opt/odoo/sources/hr, /opt/odoo/sources/hr-expense, /opt/odoo/sources/hr-holidays, /opt/odoo/sources/connector-telephony, /opt/odoo/sources/payroll, /opt/odoo/sources/odoo-l10n_ar_hr_payroll

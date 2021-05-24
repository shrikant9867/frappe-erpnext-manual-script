echo -e "********** Frappe Installation **********"

read -p "Have you installed Frappe prerequisite" prerequisite;

while true; do
    read -p "Do You Want to install installed Frappe prerequisite(y:N) -->" yn
    echo "";
    case $yn in
        [Yy]* ) echo -e "Warning: prerequisite all supported package will installed like mysql,nodejs and python. \n If you already installed mysql then abort the 	operation and restart";
        		    wget -O - https://raw.githubusercontent.com/shrikant9867/frappe-erpnext-manual-script/main/prerequisites_u18.04LTS-71Server.sh | bash;
                break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


echo -e "********** DairyERP Master Branch Installation **********"
echo ""
mkdir -p webapps/
cd webapps/
mkdir master.indictranstech.com
cd master.indictranstech.com/

echo ""
echo -e "********** Creating Virtualenv **********"
echo ""
virtualenv --python /usr/bin/python2.7 .
source ./bin/activate

echo ""
echo -e "********** Installing Bench **********"
echo ""
git clone https://gitlab+deploy-token-4:pc8ErxXA4PJsW6BzYCyR@repos.stellapps.com/mooflow/stellapps-common-codebase/bench.git bench-repo
pip install -e bench-repo
bench --help
echo ""

echo -e "********** Installing frappe-Bench Master-DairyERP **********"
echo ""
bench init --frappe-branch master https://gitlab+deploy-token-5:RpBQ4QohmyFneFpXxSGm@repos.stellapps.com/mooflow/stellapps-common-codebase/private_coop_frappe.git frappe-bench
cd frappe-bench/
echo ""

echo -e "********** Installing ERPNEXT Master **********"
echo ""
bench get-app erpnext --branch master https://gitlab+deploy-token-6:KfA7_zku18DzMAkWLitJ@repos.stellapps.com/mooflow/stellapps-common-codebase/private_coop_erpnext.git
echo ""

echo -e "********** Installing Dairy_ERP Master **********"
echo ""
bench get-app dairy_erp --branch master https://gitlab+deploy-token-7:KsYTqG34bJzLuA1xv68s@repos.stellapps.com/mooflow/stellapps-common-codebase/private_coop_dairy_erp.git
echo ""

echo -e "********** Installing paras Master **********"
echo ""
bench get-app paras	 --branch master https://gitlab+deploy-token-8:KgjVgAHFTVkUsNe8wsxz@repos.stellapps.com/mooflow/stellapps-common-codebase/vrs-paras-reports-app.git
echo ""

echo -e "********** Build all nodejs Version-13 **********"
echo ""
bench build
echo ""
echo -e "********** creating sites new-sites **********"
echo ""

echo -e "**** new site creation master.indictranstech.com ****"
wget https://master.indictranstech.com/20210524_123749-master_indictranstech_com-database.sql.gz && gzip -dk 20210524_123749-master_indictranstech_com-database.sql.gz
bench new-site master.indictranstech.com --install-app erpnext --install-app dairy_erp --install-app paras --admin-password admin --source_sql 20210524_123749-master_indictranstech_com-database.sql

echo ""
echo ""

echo "******************************* Complete **************************"
bench start

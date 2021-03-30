#!/bin/bash

############################################# Function Area #####################################
custom_installation(){
    custom_name=() #declare an array outside the scope of loop
    custom_path=()
    custom_branch=()
    url_with_path=()
    idx=0   #initialize a counter to zero
    read -p "Enter  Number Custom Apps >" num;
    for (( i = 1; i <= $num ; i++ ))
    do
        read -p "Enter Custom App Name >" custom_app_name;
        read -p "Enter Custom App path >" custom_app_path;
        read -p "Enter Custom App Branch >" custom_app_branch;
        read -p "Enter username: >" username_app;
        read -p "Enter password: >" password_app;
        custom_name[idx]=$custom_app_name;
        custom_path[idx]=$custom_app_path;
        custom_branch[idx]=$custom_app_branch;
        replace_key="://";
        new_string="://"$username_app":"$password_app"@";
        new_url_path=${custom_app_path/$replace_key/$new_string}
        url_with_path[idx]=$new_url_path
        idx=$((idx+1))
    done
}

######################################################### Before Input Execution Start from here ###############


# install ERPNEXT on Server with customized frappe & erpnext
echo -e "*************** Frappe Installation ***********************************************"
echo ""
echo ""
# Take inputs at Initial Level
echo -e "*************** Please provide Correct Data for Setup Completion ******************"
echo -n "Please Enter Python Version (2.7/3.6/3.7/3.8) >"
read py_version
echo -n "Enter the folder name for Setup > "
read application_dir
while true; do
    read -p "Do You Want to install customized bench-repo(y:N)>" yn
    case $yn in
        [Yy]* ) read -p "Enter the bench app path > " bench_path;
                read -p "Enter the bench branch >" bench_branch;
                read -p "Enter username: > "username_bench;
                read -p "Enter password: >"password_bench;
                replace_key_bench="://"
                new_string_bench="://"$username_bench":"$password_bench"@";
                new_url_path_bench=${bench_path/$replace_key_bench/$new_string_bench};
                ans1=y;
                break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
  read -p "Do You Want to install customized frappe(y:N)> " yn
  case $yn in
      [Yy]* ) read -p "Enter the Frappe app path >" frappe_app_path;
              read -p "Enter the Frappe app branch >" frappe_app_branch;
              read -p "Enter username: >" username_frappe;
              read -p "Enter password: >" password_frappe;
              replace_key_frappe="://"
              new_string_frappe="://"$username_frappe":"$password_frappe"@";
              new_url_path_frappe=${frappe_app_path/$replace_key_bench/$new_string_frappe};
              ans2=y;
              break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
done

while true; do
  read -p "Do You Want to install customized erpnext(y:N)> " yn
  case $yn in
    [Yy]* ) read -p "Enter the ERPNext app path >" erpnext_app_path;
            read -p "Enter the ERPNext app branch >" erpnext_app_branch;
            read -p "Enter username: >" username_erpnext;
            read -p "Enter password: >" password_erpnext;
            replace_key_erpnext="://"
            new_string_erpnext="://"$username_erpnext":"$password_erpnext"@";
            new_url_path_erpnext=${erpnext_app_path/$replace_key_erpnext/$new_string_erpnext};
            ans3=y;
            break;;
    [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
done

while true; do
  read -p "Do You Want to install customized Application(y:N)> " yn
  case $yn in
    [Yy]* ) custom_installation;break;;
    [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
done

while true; do
  read -p "Do you Want to run on Nginx(y:N) >" yn
  case $yn in
    [Yy]* ) read -p "Enter web port (8000/8001/8080): >" web_port;
            read -p "Enter SocketIO port (9000/9001/9002): >" socket_port;
            read -p "Enter redis_queue port (11000/11001/11002): >" redis_queue_port;
            read -p "Enter redis_socket port (12000/12001/12002): >" redis_socket_port;
            read -p "Enter redis_cache port  (13000/13001/13002): >" redis_cache_port;
            ans4=y;
            break;;
    [Nn]* ) ans4=n;
  esac
done

read -p "Enter the Site Name: >" site_name;
read -p "Enter MYSQL ROOT password: >" mysql_root_password;
read -p "Enter Administrator password for UI: >" admin_password;


######################################################## After Input Execution ###########################

echo ""
echo -e "**************************** Installation Started ************************************************"
echo ""
mkdir -p webapps
cd webapps

if [ -d $application_dir ]
then
    echo "Directory "$application_dir" exists."
    exit 0;
else
    mkdir $application_dir
fi

cd $application_dir
echo "****************************** Creating virtualenv *************************************************"

virtualenv -p /usr/bin/python$py_version .
source ./bin/activate

if [ "$ans1" == 'y' ];
then
        echo -e "************ Git Clone Bench-repo $bench_path ************"
        git clone -b $bench_branch $new_url_path_bench bench-repo
else
        echo -e "************ Git Clone Bench-repo https://github.com/frappe/bench ************"
        git clone -b master https://github.com/frappe/bench bench-repo
fi

pip install -e bench-repo

if [ "$ans2" == 'y' ];
then
        echo "************ Installing Frappe-bench from $frappe_app_path using branch $frappe_app_branch ************"
        bench init --frappe-branch $frappe_app_branch --frappe-path $new_url_path_frappe frappe-bench
else
        echo "************ Installing Frappe-bench from https://github.com/frappe/frappe using branch master ********"
        bench init --frappe-branch master frappe-bench
fi

cd frappe-bench
source ../bin/activate

if [ "$ans3" == 'y' ];
then
        echo -n "************ Installing ERPNext from $erpnext_app_path using branch $erpnext_app_branch ************"
        bench get-app --branch $erpnext_app_branch erpnext $new_url_path_erpnext
else
        echo "************ Installing ERPNext from https://github.com/frappe/erpnext using branch master ********"
        bench get-app erpnext --branch master erpnext https://github.com/frappe/erpnext.git
fi

for (( i=0; i<$num; i++)); do
  echo -n "************ Installing ${custom_name[$i]} from ${custom_path[$i]} using branch ${custom_branch[$i]} ************"
  bench get-app --branch ${custom_branch[$i]} ${custom_name[$i]} ${new_url_path[$i]}
done

bench new-site $site_name --mariadb-root-password $mysql_root_password --admin-password $admin_password --install-app erpnext

for (( i=0; i<$num; i++)); do
  echo -e "************** Installing Custom App in site ***************************"
  bench install-app ${custom_app_name[$i]}
done  

bench setup nginx
bench setup supervisor
echo -n "Enter the hostname for setting up nginx > "
read nginx_name
sudo ln -s `pwd`/config/nginx.conf /etc/nginx/sites-available/$nginx_name.conf
sudo ln -s /etc/nginx/sites-available/$nginx_name.conf /etc/nginx/sites-enabled/$nginx_name.conf
sudo ln -s `pwd`/config/supervisor.conf /etc/supervisor/conf.d/$nginx_name.conf
sudo supervisorctl reload
sudo service nginx reload

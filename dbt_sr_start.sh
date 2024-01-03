export http_proxy=http://10.11.23.14:7890;
export https_proxy=http://10.11.23.14:7890;
apt-get update
apt-get install -y vim git curl wget net-tools iputils-ping
git clone git@github.com:lllong33/mrr-playbook.git
cd mrr-playbook
pip install -r requirements.txt
dbt deps
dbt debug
dbt run 
dbt test
dbt docs generate
nohup dbt docs serve 2>&1 > docs_nohup.log 2>&1 &
tail -200f docs_nohup.log

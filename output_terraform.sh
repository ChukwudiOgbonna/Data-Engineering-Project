# Bash script to output terraform variables to env variables to be used by airflow

# change directory
cd ./learn-terraform-aws-instance

# run terraform
terraform apply

# echo variables to .env file iin airflow directory
echo MYSQL_HOST = "$(terraform output -raw mysql_host)" >> ../airflow/.env
echo MYSQL_PORT = "$(terraform output -raw mysql_port)" >> ../airflow/.env
echo MYSQL_USERNAME = "$(terraform output -raw mysql_username)" >> ../airflow/.env
echo MYSQL_PASSWORD = "$(terraform output -raw mysql_password)" >> ../airflow/.env
echo MYSQL_DB_NAME = "$(terraform output -raw mysql_database_name)" >> ../airflow/.env
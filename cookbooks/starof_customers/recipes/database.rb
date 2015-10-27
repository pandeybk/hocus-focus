#
# Cookbook Name:: starof_customers
# Recipe:: database
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


# Configure the mysql2 Ruby gem.
mysql2_chef_gem 'default' do
    action :install
end

# Configure the MySQL client.
mysql_client 'default' do
    action :create
end

# Load the secrets file and the encrypted data bag item that holds the root password.
password_secret = Chef::EncryptedDataBagItem.load_secret(node['starof_customers']['passwords']['secret_path'])
root_password_data_bag_item = Chef::EncryptedDataBagItem.load('passwords', 'sql_server_root_password', password_secret)
user_password_data_bag_item = Chef::EncryptedDataBagItem.load('passwords', 'db_admin_password', password_secret)


# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password root_password_data_bag_item['password']
  action [:create, :start]
end


# Create the database instance.
mysql_database 'products' do
  connection(
    :host => node['starof_customers']['database']['host'],
    :username => node['starof_customers']['database']['username'],
    :password => root_password_data_bag_item['password']
  )
  action :create
end

# Add a database user.
mysql_database_user 'db_admin' do
  connection(
    :host => node['starof_customers']['database']['host'],
    :username => node['starof_customers']['database']['username'],
    :password => root_password_data_bag_item['password']
  )
  password user_password_data_bag_item['password']
  database_name node['starof_customers']['database']['dbname']
  host node['starof_customers']['database']['host']
  action [:create, :grant]
end

# Write schema seed file to filesystem.
cookbook_file '/tmp/create-tables.sql' do
  source 'create-tables.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Seed the database with a table and test data.
execute 'initialize database' do
  command "mysql -h #{node['starof_customers']['database']['host']} -u #{node['starof_customers']['database']['app']['username']} -p#{user_password_data_bag_item['password']} -D #{node['starof_customers']['database']['dbname']} < #{node['starof_customers']['database']['seed_file']}"

  not_if  "mysql -h #{node['starof_customers']['database']['host']} -u #{node['starof_customers']['database']['app']['username']} -p#{user_password_data_bag_item['password']} -D #{node['starof_customers']['database']['dbname']} -e 'describe customers;'"
end
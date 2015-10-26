default['starof_customers']['user'] = 'web_admin'
default['starof_customers']['group'] = 'web_admin'

default['starof_customers']['document_root'] = '/var/www/customers/public_html'

default['firewall']['allow_ssh'] = true

default['starof_customers']['passwords']['secret_path'] = '/etc/chef/encrypted_data_bag_secret'

default['starof_customers']['database']['dbname'] = 'products'
default['starof_customers']['database']['host'] = '127.0.0.1'
default['starof_customers']['database']['username'] = 'root'
default['starof_customers']['database']['app']['username'] = 'db_admin'


default['starof_customers']['database']['seed_file'] ='/tmp/create-tables.sql'
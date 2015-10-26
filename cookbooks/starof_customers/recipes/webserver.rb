#
# Cookbook Name:: starof_customers
# Recipe:: webserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Install Apache and start the service.
httpd_service 'customers' do
    mpm 'prefork'
    action [:create, :start]
end

# Add the site configuration.
httpd_config 'customers' do
    instance 'customers'
    source 'customers.conf.erb'
    notifies :restart, 'httpd_service[customers]'
end

# Create the document root directory.
directory node['starof_customers']['document_root'] do
    recursive true
end

# Write a default home page.
file "#{node['starof_customers']['document_root']}/index.php" do
    content '<html> Hello world to Chef! </html>'
    mode '0644'
    owner node['starof_customers']['user']
    group node['starof_customers']['group']
end

# Open port 80 to incoming traffic.
firewall_rule 'http' do
  port 80
  protocol :tcp
  action :allow
end
#
# Cookbook Name:: starof_customers
# Recipe:: user
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

group node['starof_customers']['user']

user node['starof_customers']['user'] do
    group node['starof_customers']['group']
    system true
    shell '/bin/bash'
end
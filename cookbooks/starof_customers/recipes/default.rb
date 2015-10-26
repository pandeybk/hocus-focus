#
# Cookbook Name:: starof_customers
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt::default'
include_recipe 'starof_customers::user'
include_recipe 'firewall::default'
include_recipe 'starof_customers::webserver'
include_recipe 'starof_customers::database'
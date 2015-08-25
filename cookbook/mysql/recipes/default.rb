#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
target_file = "mysql-community-release-el6-5.noarch.rpm"
target_path = "#{Chef::Config[:file_cache_path]}/#{target_file}"

remote_file  "#{target_path}" do
  source "http://repo.mysql.com/#{target_file}"
  notifies :install, "rpm_package[mysql.repo]", :immediately
end

rpm_package "mysql.repo" do
  source "#{target_path}"
  action :nothing
end

yum_package "mysql" do
  action :install
end

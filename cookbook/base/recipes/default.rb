#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 日付ロケール設定
cookbook_file "/etc/sysconfig/clock" do
  source "clock"
end

link "/etc/localtime" do
  to "/usr/share/zoneinfo/Asia/Tokyo"
end

# パッケージインストール（tree, mlocate）
package "tree" do
  action :install
end
package "mlocate" do
  action :install
end


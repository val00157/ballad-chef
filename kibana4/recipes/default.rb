#
# Cookbook Name:: kibana4
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# /tmpにkibana4をダウンロードして展開したファイルをコピーすることでkibana4のインストールを行なう。
bash "install kibana4" do
  user "root"
  cwd "/tmp"
  code <<-EOC
    kibana4="kibana-4.0.2-linux-x64"
    wget https://download.elastic.co/kibana/kibana/${kibana4}.tar.gz
    tar xvzf ${kibana4}.tar.gz
    mv ${kibana4} /etc/kibana4
  EOC
  creates "/etc/kibana4"
end

# 起動ファイルをコピーして、設定・実行する。
cookbook_file "/etc/rc.d/init.d/kibana4" do
  source "kibana4"
  mode "655"
end
service "kibana4" do
  supports :status => true, :restart => true
  action [:enable, :restart]
end

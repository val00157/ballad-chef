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

# パッケージインストール（tree, mlocate, jq）
package "tree" do
  action :install
end
package "mlocate" do
  action :install
end
package "jq" do
  action :install
end

# リージョン情報を環境変数及びコマンドラインツールのコンフィグ情報に設定する。
bash "set_region" do
  code <<-EOL
    target=${HOME}/.bashrc
    if [ `grep EC2_URL ${target} | wc -l` -eq 0 ]; then
      echo "export EC2_URL=https://ec2.ap-northeast-1.amazonaws.com" >> ${target}
    fi
    if [ `grep EC2_REGION ${target} | wc -l` -eq 0 ]; then
      echo "export EC2_REGION=ap-northeast-1" >> ${target}
    fi
    aws configure set region ap-northeast-1
  EOL
end

# gemパッケージtireインストール
gem_package "tire" do
  action :install
end

# indexの再作成スクリプトと日次で実行するスクリプトを展開する
cookbook_file "/home/ec2-user/reindex.rb" do
  source "reindex.rb"
end
cookbook_file "/home/ec2-user/generate_index.sh" do
  source "generate_index.sh"
end

# cron登録
cron "generate_elasticsearch_index" do
  user "ec2-user"
  minute "0"
  hour "0"
  command "/home/ec2-user/generate_index.sh"
end


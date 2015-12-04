# elasticsearchプラグインのインストール
gem_package "fluent-plugin-elasticsearch" do
  gem_binary "/opt/td-agent/embedded/bin/fluent-gem"
  action :install
end

# 設定ファイルの書き換え
template "/etc/td-agent/td-agent.conf" do
  source "collector.erb"
end


# サービス再起動
service "td-agent" do
  supports :status => true, :restart => true
  action [:enable, :restart]
end



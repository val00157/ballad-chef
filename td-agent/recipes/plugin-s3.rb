# elasticsearchプラグインのインストール
gem_package "fluent-plugin-s3" do
  gem_binary "/opt/td-agent/embedded/bin/fluent-gem"
  action :install
end

# サービス再起動
service "td-agent" do
  supports :status => true, :restart => true
  action [:enable, :restart]
end



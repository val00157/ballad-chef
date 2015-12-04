# balladの稼働環境情報を設定する起動スクリプトをインストールする
cookbook_file "/etc/init.d/setBalladConfig" do
  source "setBalladConfig"
  mode 00755
end

bash "chkconfig" do
  code <<-EOL
    chkconfig --add setBalladConfig
  EOL
end

service "setBalladConfig" do
  action [:start, :enable]
end

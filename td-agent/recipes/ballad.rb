stack = node[:opsworks][:stack][:name] 
params = data_bag_item(stack, "td-agent")

# confファイルのコピー
%w{
  ballad
  beta
  dev
}.each do |tagName|
  template "/etc/td-agent/td-agent.#{tagName}" do
    source "td-agent.#{tagName}.erb"
    variables(
        :params => params
    )
  end
end

# setBalladConfigを実行して稼働環境にあったconfigファイルに置き換える
service "setBalladConfig" do
  action :start
end

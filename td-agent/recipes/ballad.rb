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


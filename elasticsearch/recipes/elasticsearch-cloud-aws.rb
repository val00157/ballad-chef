stack = node[:opsworks][:stack][:name] 
params = data_bag_item("elasticsearch", stack)["elasticsearch"]

# インストール
bash "elasticsearch-cloud-aws" do
  cwd "/usr/share/elasticsearch"
  code <<-EOC
    bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.5.0
  EOC
  creates "/usr/share/elasticsearch/plugins/cloud-aws"
end

# data_bagのパラメータを渡してymlファイルを展開する。
template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch-cloud-aws.yml.erb"
  variables(
      :params => params
  )
end

# elasticsearchのパラメータを設定する。
bash "set_sysconfig" do
  user "root"
  cwd "/etc/sysconfig/"
  code <<-EOC
    sed -i -e "s/#*ES_HEAP_SIZE=.*/ES_HEAP_SIZE=18000M/" elasticsearch
    if [ `grep -i -c "ES_HEAP_SIZE" elasticsearch` -eq 0 ]; then 
      echo "ES_HEAP_SIZE=18000M" > elasticsearch
    fi
  EOC
end

# サービスを開始する。
service "elasticsearch" do
  supports :status => true, :restart => true
  action [:enable, :restart]
end

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

  targets = params["sysconfig"]
  targets.each do |key, value|   
    code <<-EOC
      sed -i -e "s/#*#{key}=.*/#{key}=#{value}/" elasticsearch
      if [ `grep -i -c "#{key}" elasticsearch` -eq 0 ]; then 
        echo "#{key}=#{value}" > elasticsearch
      fi
    EOC
  end
end

# サービスを開始する。
service "elasticsearch" do
  supports :status => true, :restart => true
  action [:enable, :restart]
end

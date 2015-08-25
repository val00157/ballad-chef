stack = node[:opsworks][:stack][:name] 
params = data_bag_item("elasticsearch", stack)["elasticsearch"]

bash "elasticsearch-cloud-aws" do
  cwd "/usr/share/elasticsearch"
  code <<-EOC
    bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.5.0
  EOC
  creates "/usr/share/elasticsearch/plugins/cloud-aws"
end

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch-cloud-aws.yml.erb"
  variables(
      :params => params
  )
end

service "elasticsearch" do
  supports :status => true, :restart => true
  action [:enable, :restart]
end

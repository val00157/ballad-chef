bash "elasticsearch-head" do
  cwd "/usr/share/elasticsearch"
  code <<-EOC
    bin/plugin -install mobz/elasticsearch-head
  EOC
  creates "/usr/share/elasticsearch/plugins/head"
end
service "elasticsearch" do
  action :restart
end

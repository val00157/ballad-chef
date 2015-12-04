bash "elasticsearch-head" do
  cwd "/usr/share/elasticsearch"
  code <<-EOC
    bin/plugin -install elasticsearch/elasticsearch-analysis-kuromoji/2.5.0
  EOC
  creates "/usr/share/elasticsearch/plugins/analysis-kuromoji"
end
service "elasticsearch" do
  action :restart
end

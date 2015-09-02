bash "Install packages" do
  code <<-EOL
    user "root"
    pip install awsebcli
  EOL
end

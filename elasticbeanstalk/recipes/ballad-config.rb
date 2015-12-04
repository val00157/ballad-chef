# Elastic Beanstalkコマンドラインツールを使ってballad環境設定を行なう。
## eb setenvコマンドでElastic Beanstalkの環境変数が設定されます。
stack = node[:opsworks][:stack][:name] 
params = data_bag_item(stack, "eb")

bash "setEnv" do
  user "root"
  code <<-EOL
    eb use params["EB_ENVIRONMENT"]
    eb setenv AWS_ACCESS_KEY_ID=params["AWS_ACCESS_KEY_ID"]                                     \
              AWS_SECRET_KEY=params["AWS_SECRET_KEY"]                                           \
              AWS_PROPERTY_DOMAIN_URL=params["AWS_PROPERTY_DOMAIN_URL"]                         \
              AWS_PROPERTY_IMAGE_SERVER_URL=params["AWS_PROPERTY_IMAGE_SERVER_URL"]             \
              AWS_PROPERTY_STATIC_FILE_SERVER_URL=params["AWS_PROPERTY_STATIC_FILE_SERVER_URL"] \
              AWS_PROPERTY_TAG_NAME=params["AWS_PROPERTY_TAG_NAME"]                             \
              S3BUCKET=params["S3BUCKET"]
  EOL
end

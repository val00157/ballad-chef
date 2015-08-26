stack = node[:opsworks][:stack][:name] 
params = data_bag_item("kibana4", stack)["kibana4"]

bash "ELB added Instance" do
  user "root"
  environment(
    "ACCESS_KEY" => params["AWS_ACCESS_KEY"],
    "SECRET_KEY" => params["AWS_SECRET_KEY"],
    "REGION"     => params["AWS_REGION"],
    "ELB_NAMES"  => params["ELB_NAMES"]
  )
  code <<-EOC
    PATH=$PATH:/opt/aws/bin
    export AWS_ELB_HOME=/opt/aws/apitools/elb
    export JAVA_HOME=/usr/lib/jvm/java

    INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id 2> /dev/null`

    declare -a elbs=(${ELB_NAMES})
    for elb in ${elbs[@]}; do
      elb-register-instances-with-lb ${elb} --instances ${INSTANCE_ID} --region ${REGION} --access-key-id ${ACCESS_KEY} --secret-key ${SECRET_KEY}
    done
  EOC
end


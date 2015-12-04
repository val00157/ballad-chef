# kibanaを起動しているEC2インスタンスを指定したELBに接続する。
# ELBは空白区切りで複数指定可能
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
    # パス設定、環境変数設定を行なう。
    PATH=$PATH:/opt/aws/bin
    export AWS_ELB_HOME=/opt/aws/apitools/elb
    JAVA_HOME=/usr/lib/jvm/java
    if [ ! -e ${JAVA_HOME}/bin/java ]; then
        JAVA_HOME=/usr/lib/jvm/jre
        if [ ! -e ${JAVA_HOME}/bin/java ]; then
            JAVA_HOME=`which java | sed -e "s/\/bin\/java//"`
        fi
    fi
    export JAVA_HOME

    # 自身のインスタンスIDを取得する。
    INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id 2> /dev/null`

    # ELBの名前の配列を作成する。
    declare -a elbs=(${ELB_NAMES})

    # ELBにインスタンスを接続する。
    for elb in ${elbs[@]}; do
        elb-register-instances-with-lb ${elb} --instances ${INSTANCE_ID} --region ${REGION} --access-key-id ${ACCESS_KEY} --secret-key ${SECRET_KEY}
    done
  EOC
end


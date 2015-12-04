# ディスクモニタのCloudWatchメトリクスを登録するレシピ
stack = node[:opsworks][:stack][:name] 
params = data_bag_item(stack, "monitor")["CloudWatch"]
targets = params["disk-usage"]["MONITORING_MOUNT_DIRECTORY"].split(/\s+|\s*,\s*/)

targets.each do |path|
    params["Alarms"].each do |cwParams|
        bash "" do
          user "root"
          environment(
            "ACCESS_KEY"    => params["AWS_ACCESS_KEY"],
            "SECRET_KEY"    => params["AWS_SECRET_KEY"],
            "REGION"        => params["AWS_REGION"],
            "ALARM_NAME"    => cwParams["CW_ALARM_NAME"],
            "METRIC_NAME"   => cwParams["CW_METRIC_NAME"],
            "VALUE"         => cwParams["CW_THRESHOLD_VALUE"],
            "ARN"           => cwParams["CW_ALARM_ACTION_ARN"],
            "TARGET"        => path
          )
          code <<-EOC
            source ~/.bashrc

            export AWS_GENERAL_OPTIONS="-I ${ACCESS_KEY} -S ${SECRET_KEY} --region ${REGION}"
            instanceId=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
            alarmName="${ALARM_NAME}-${instanceId}"

            mon-put-metric-alarm \
                ${alarmName} \
                --comparison-operator GreaterThanOrEqualToThreshold \
                --evaluation-periods 1 \
                --metric-name ${METRIC_NAME} \
                --namespace "System/Linux" \
                --dimensions "InstanceId=${instanceId},Path=${TARGET}" \
                --unit "Percent" \
                --period 300 \
                --statistic Average \
                --threshold ${VALUE} \
                --alarm-actions ${ARN} \
                ${AWS_GENERAL_OPTIONS}
          EOC
        end
    end
end

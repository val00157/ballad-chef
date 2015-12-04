# ディスク容量モニタリングを設定するレシピ
stack = node[:opsworks][:stack][:name] 
params = data_bag_item(stack "monitor")["CloudWatch"]

# ディスク容量モニタリングシェルを展開する
template "/root/monitor-disk-usage.sh" do
  source "monitor-disk-usage.sh.erb"
  variables(
      :params => params
  )
  mode 775
end

# ディスク容量モニタリングシェルをcron登録する
targets = params["disk-usage"]["MONITORING_MOUNT_DIRECTORY"].split(/\s+|\s*,\s*/)
targets.each do |path|
  cron "Monitor Disk Usage(" + path + ")"  do
    user "root"
    minute "*/5"
    command "/root/monitor-disk-usage.sh " + path
  end
end

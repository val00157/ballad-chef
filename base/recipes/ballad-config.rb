# OpsWorksエージェントがmonitd.confを書き換えてしまい
# 既存のconfファイルが読み込めないのでmonitrcファイルとしてシンボリックリンクを作成する。
bash "monit_config" do
  user 'root'
  cwd '/etc/monit.d/'
  code <<-EOL
    for filename in *; do
      extension=${filename##*.}
      if [ $extension != "monitrc" ]; then
        linkname=${filename%.*}.monitrc
        ln -s ${filename} ${linkname}
      fi
    done
  EOL
end


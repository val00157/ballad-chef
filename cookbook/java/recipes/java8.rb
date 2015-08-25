package 'java-1.8.0-openjdk-devel' do
  action :install
end
bash "alternatives java" do
  user "root"
  code <<-EOC
    OLDIFS=IFS
    IFS="
"
    for i in `alternatives --display java`; do
      target=`echo $i | cut -d " " -f 1`
      if [ -n "${target}" ]; then 
        if [ `expr ${target} : '/'` -eq 1 ]; then
          if [ `echo ${target} | grep java-1.8.0-openjdk` ]; then
            alternatives --set java  ${target}
          fi
        fi
      fi
    done
    IFS=$OLDIFS
  EOC
end




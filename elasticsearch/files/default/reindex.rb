### indexの再作成スクリプト
#### /home/ec2-user/reindex.rb
require 'tire'

old_index_name = ARGV[0]
new_index_name = ARGV[1]

idx = Tire::Index.new(old_index_name)
idx.reindex(new_index_name)


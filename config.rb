file_cache_path "/tmp/chef-solo"

base = File.expand_path('..', __FILE__)
cookbook_path [base + '/cookcook']
data_bag_path [base + '/data_bags']
node_path [base + '/nodes']


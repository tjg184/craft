app_home = node['craft']['app_home']
craft_home = node['craft']['craft_home']
apache_user = node['craft']['apache_user']
apache_dir = node['craft']['apache_dir']

%w{app storage config}.each do |dir|
  directory "#{craft_home}/craft/#{dir}" do
    owner "#{apache_user}"
    group "root"
    mode "0755"
    recursive true
  end
end

#update craft/config/db.php
template "#{craft_home}/craft/config/db.php" do
  source "db.php.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
    :host => node['craft']['db']['host'] ,
    :user => node['craft']['db']['user'],
    :password => node['craft']['db']['password'],
    :database => node['craft']['db']['database'],
    :prefix => node['craft']['db']['prefix']
  })
  notifies :restart, "service[apache2]", :delayed
end

template "#{craft_home}/craft/config/general.php" do
  source "general.php.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :restart, "service[apache2]", :delayed
  action :create_if_missing
end

if node['craft']['license']
  cookbook_file "#{craft_home}/craft/config/license.key" do
    source  'license.key'
    owner "root"
    group "root"
    mode  "0644"
    action :create_if_missing
  end
end

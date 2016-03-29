apache_user = node['apache']['user']
apache_dir = node['apache']['dir']

default['craft']['install']['version']['major'] = '2.4'
default['craft']['install']['version']['minor'] = '2670'
default['craft']['install']['url'] = 'http://download.buildwithcraft.com/craft'
default['craft']['install']['mode'] = 'auto'
default['craft']['app_home'] = '/opt'
default['craft']['mode']['dev'] = false
default['craft']['mode']['craft_dir'] = '/vagrant/craft'
default['craft']['mode']['public_dir'] = '/vagrant/public'
default['craft']['craft_home'] = "#{node['craft']['app_home']}/craft"
default['craft']['db']['host'] = '127.0.0.1'
default['craft']['db']['user'] = 'root'
default['craft']['db']['password'] = 'changeme'
default['craft']['db']['database'] = 'craft'
default['craft']['db']['prefix']  = 'craft'
default['craft']['db']['sql_path']  = '/vagrant/craft.sql'
default['craft']['ports']['http_port'] = '80'
default['craft']['ports']['https_port'] = '443'
default['craft']['apache_user'] = apache_user
default['craft']['apache_dir'] = apache_dir
default['craft']['cert'] = "#{node['craft']['apache_dir']}/ssl/craft.pem"
default['craft']['license'] = true

default['apache']['listen_ports'] = [ "#{node['craft']['ports']['https_port']}", "#{node['craft']['ports']['http_port']}"]

#version checksums here
default['craft']['2.4.2670'] = 'eb352bc60f4c1cd9beb7c2a24d4250c825b3f60a3dd65f9e34f37b586dc33588'
default['craft']['app_version'] = 'master'

# necessary for phpmyadmin
default['mysql']['root_group'] = 'root'
default['mysql']['mysql_bin'] = 'mysql'
default['mysql']['server_root_password'] = 'changeme'
node.override['phpmyadmin']['cfg']['allow_root'] = true

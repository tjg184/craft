include_recipe "apache2"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mpm_prefork"
include_recipe "php"

# EPEL repo
if %w{rhel}.include?(node['platform_family'])
  execute 'yum update -y ca-certificates'
	include_recipe 'yum-epel'
end

include_recipe "php::module_mysql"
include_recipe "php::module_curl"
include_recipe "php::module_gd"
include_recipe "craft::module_mcrypt"
include_recipe "craft::module_mbstring"

app_home = node['craft']['app_home']
craft_home = node['craft']['craft_home']
major = node['craft']['install']['version']['major']
minor = node['craft']['install']['version']['minor']
version = "#{major}.#{minor}"
url = "#{node['craft']['install']['url']}"

if node['craft']['install']['mode'] == 'auto'
  install_url = "#{url}/#{major}/#{version}/Craft-#{version}.tar.gz"
else
  install_url = url
end

#setup dirs
directory craft_home do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

if node['craft']['mode']['dev']
  link "#{craft_home}/craft" do
    to "#{node['craft']['mode']['craft_dir']}"
  end
  link "#{craft_home}/public" do
    to "#{node['craft']['mode']['public_dir']}"
  end
else
  ark 'craft' do
    url install_url
    path app_home
    checksum node['craft']["#{version}"] if node['craft']['install']['mode'] == 'auto'
    strip_components 0
    action :put
  end
end

include_recipe 'craft::configure'
include_recipe 'craft::apache'

#
# Cookbook Name:: craft
# Recipe:: default
#
include_recipe "craft::install"
include_recipe "craft::mysql"

if node['craft']['mode']['dev']
  include_recipe "phpmyadmin"
end

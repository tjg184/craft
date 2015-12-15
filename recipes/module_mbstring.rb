package 'php-mbstring' do
  action :install
  only_if { platform_family?('rhel', 'fedora') }
end

pkg = value_for_platform_family(
    [ 'rhel', 'fedora' ] => 'php-mcrypt',
    'debian' => 'php5-mcrypt'
)

package pkg do
  action :install
  notifies(:run, "execute[/usr/sbin/php5enmod mcrypt]", :immediately) if platform?('ubuntu') && node['platform_version'].to_f >= 12.04
end

execute '/usr/sbin/php5enmod mcrypt' do
  action :nothing
  only_if { platform?('ubuntu') && node['platform_version'].to_f >= 12.04 && ::File.exists?('/usr/sbin/php5enmod') }
end

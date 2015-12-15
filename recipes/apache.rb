apache_user = node['craft']['apache_user']
apache_dir = node['craft']['apache_dir']
craft_home = node['craft']['craft_home']

directory "#{craft_home}/public" do
    owner "#{apache_user}"
    group "root"
    mode "0755"
end

file "#{craft_home}/public/htaccess" do
  action :delete
end

template "#{craft_home}/public/.htaccess" do
  source "public.htaccess.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "#{apache_dir}/sites-available/craft.conf" do
  source "apache-site.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
    :http_port => node['craft']['ports']['http_port'],
    :https_port => node['craft']['ports']['https_port'],
    :docroot =>  "#{craft_home}/public",
    :server_name => node['hostname'],
    :server_aliases => [node['fqdn'], "*"],
    :ssl_crt => node['craft']['cert'],
    :ssl_key => node['craft']['cert'],
    :name => "craft",
    :allow_override => "All"
  })
  notifies :restart, "service[apache2]", :delayed
end

#Generate self signed certs if cert doesn't exist on the file system
if not  ::File.exists?(node['craft']['cert'] )
  bash "gen temp ssl certs for testing" do
    code <<-EOS
        openssl genrsa -out /tmp/tmp.key 4096
        openssl req -subj "/C=US/ST=UT/L=SLC/O=JB/OU=IT/CN=Tester/emailAddress=noreply@jamberry.com" -new -key /tmp/tmp.key -out /tmp/tmp.csr
        openssl x509 -req -days 365 -in /tmp/tmp.csr -signkey /tmp/tmp.key -out /tmp/tmp.crt
        cat /tmp/tmp.{key,crt} >> #{node['craft']['cert']}
        rm -f /tmp/tmp.{csr,key,crt}
        EOS
   if not ::File.exists?(node['craft']['cert'])
     puts "#{node['craft']['cert']}"
   end
  end
end

link "#{apache_dir}/sites-enabled/craft.conf" do
 to "#{apache_dir}/sites-available/craft.conf"
end


sql_path = node['craft']['db']['sql_path']
database = node['craft']['db']['database']
user = node['craft']['db']['user']
password = node['craft']['db']['password']
host = node['craft']['db']['host']
mysql_instance = 'default'
socket = "/var/run/mysql-#{mysql_instance}/mysqld.sock"

mysql_service "#{mysql_instance}" do
  port '3306'
  version '5.5'
  initial_root_password "#{password}"
  action [:create, :start]
end

# make it easier to connect from the command line or any client library
file '/etc/my.cnf' do
  content "[client]\nsocket=#{socket}"
  mode '0755'
  owner 'root'
  group 'root'
end

# make there only 1 mysql instance
link "/var/run/mysqld/mysqld.sock" do
  to "#{socket}"
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_database "#{database}" do
  connection(
    :host => "#{host}",
    :socket => "#{socket}",
    :username => "#{user}",
    :password => "#{password}"
  )
  action :create
end

execute 'load_craft' do
  command "mysql -h #{host} -u #{user} -p#{password} #{database} < #{sql_path}"
  only_if {File.exists?("#{sql_path}")}
end

#
# Cookbook Name:: mysql-community-server
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "mysql-community-server" do
  action :install
  version "5.6.21-2.el6"
end



service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# secure install
root_password = node["mysql-community-server"]["root_password"]
execute "secure_install" do
  command "/usr/bin/mysql -u root < #{Chef::Config[:file_cache_path]}/secure_install.sql"
  action :nothing
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template "#{Chef::Config[:file_cache_path]}/secure_install.sql" do
  owner "root"
  group "root"
  mode 0644
  source "secure_install.sql.erb"
  variables({
    :root_password => root_password,
  })
  notifies :run, "execute[secure_install]", :immediately
end

#
# Cookbook Name:: apache_git_site
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# Supported OS - CentOS 7.1

# Ensure network service is running
service 'network.service' do
  action [:enable, :start]
end

# Ensure sshd service is running
service 'sshd.service' do
  action [:enable, :start]
end

# Ensure firewalld service is running
service 'firewalld.service' do
  action [:enable, :start]
end

# Enable enp0s3
bash 'Enable Ethernet connection' do
  code <<-EOH
  sed -i.bak s/ONBOOT=no/ONBOOT=yes/g
    /etc/sysconfig/network-scripts/ifcfg-enp0s3
  systemctl restart network.service
  EOH
  action :run
  not_if 'cat /etc/sysconfig/network-scripts/ifcfg-enp0s3 | grep ONBOOT=yes'
end

# Enable http service in firewall
bash 'Enable http service in firewall' do
  code <<-EOH
    firewall-cmd --zone=public --add-service=http
  EOH
  not_if 'firewall-cmd --list-service | grep http'
end

# Enable ssh service in firewall
bash 'Enable ssh service in firewall' do
  code <<-EOH
    firewall-cmd --zone=public --add-service=ssh
  EOH
  not_if 'firewall-cmd --list-service | grep ssh'
end

# Install Apache
package 'Install Apache' do
  package_name 'httpd'
  action :install
end

# Ensure httpd service is running
service 'httpd.service' do
  action [:enable, :start]
end

# Install PHP
package 'php' do
  action :install
end

# Install Git
package 'Install Git' do
  package_name 'git'
  action :install
end

# Pull down on GitHub repo
git '/var/www/html' do
  repository "#{node['repo']}"
  action :sync
end

# Set index.php as default index file
cookbook_file '/var/www/html/.htaccess' do
  source '.htaccess'
  action :create
  notifies :restart, 'service[httpd.service]', :immediately
end

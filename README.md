# apache_git_site

This is a <a href = "https://chef.io"<a>Chef</a> cookbook that runs on CentOS 7.1. 

The cookbook does the following:
-Enables necessary services: networking.service; sshd.service; firewalld.service; httpd.service
-Adds firewall entries for necessary services: http; ssh;
-Installs the following: Apache, PHP, git
-Pulls down from a user specified repository listed in the default attributes file.

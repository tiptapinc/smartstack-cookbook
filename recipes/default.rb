# set up common smartstack stuff
user node.smartstack.user do
  home    node.smartstack.home
  shell   '/sbin/nologin'
  system  true
end

directory node.smartstack.home do
  owner     node.smartstack.user
  group     node.smartstack.user
  recursive true
end

# we need git to install smartstack
package 'git'

# we use runit to set up the services
include_recipe 'runit'

# use Brightbox so we can run older ruby version
# on later Ubuntu installs. Have successfully tried
# 
# ruby 1.9.1 with ubuntu 16.04
#
execute "apt-add-repository ppa:brightbox/ruby-ng" do
  user "root"
end

execute "apt-get update" do
  user "root"
end

execute "apt-get -y remove ruby" do
  user "root"
end

execute "apt-get -y install ruby1.9.1-dev" do
  user "root"
end

execute "apt-get -y install ruby-switch" do
  user "root"
end

execute "ruby-switch --set ruby1.9.1" do
  user "root"
end

# execute "apt-get -y install ruby2.5 ruby2.5-dev" do
#   user "root"
# end

# execute "apt-get -y install ruby-switch" do
#   user "root"
# end

# execute "ruby-switch --set ruby2.5" do
#   user "root"
# end

gem_package 'bundler'

# clean up old crap
# TODO: remove eventually
%w{/opt/nerve /opt/synapse}.each do |old_dir|
  directory old_dir do
    action :delete
    recursive true
  end
end

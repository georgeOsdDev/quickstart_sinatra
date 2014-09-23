For ruby + mysql development

### Download

* Vagrant 1.6.5
 https://www.vagrantup.com/downloads.html

* ChefDK
 http://downloads.getchef.com/chef-dk/mac/#/


```
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-omnibus
vagrant box add centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box
```

```
cd path/to/vagrant_workspace
# vagrant init centos65
gem install berkshelf
berks
vagrant up
vagrant ssh

```

```
sudo chmod 777 /opt/rbenv
sudo chmod 777 /opt/rbenv/versions
sudo chmod 777 /opt/rbenv/shims
git clone https://github.com/sstephenson/ruby-build.git /tmp/ruby-build
sudo mv /tmp/ruby-build /opt/rbenv/plugins/
rbenv install 2.1.2
rbenv global 2.1.2
gem install bundler
```

Server application source code (`../src` at host OS) will be synced as `/opt/src` to guest OS.

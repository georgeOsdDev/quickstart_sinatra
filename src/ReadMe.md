## How do I get started?

## Requirements

* [ruby](https://www.ruby-lang.org/en/) 2.1.2
* [gem](https://rubygems.org/) 2.2.2
* [bundler](http://bundler.io/) 1.7.2

```
[vagrant@ruby src]$ ruby -v
ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-linux]
[vagrant@ruby src]$ gem -v
2.2.2
[vagrant@ruby src]$ bundle -v
Bundler version 1.7.2
```

You can use [rbenv](https://github.com/sstephenson/rbenv) to install these requirements.

## Clone repository and install gems

```
git clone git://path/to/repo
cd path/to/server/app
bundle install --path vendor/bundle
```

# How do I start the application?

Start the app by running:

    bundle exec rake s

## Helper Rake Tasks

There are a few helper Rake tasks that will help you to clear and compile your Sass stylesheets as well as a few other helpful tasks. There is also a generate task, so you can generate a new project at a defined location based on the bootstrap.

    bundle exec rake -T

    rake db:migrate  # Migrate the database
    rake generate    # Generate a new project at dir=foo
    rake routes      # List all routes for this application
    rake s           # Run the app
    rake test        # Run tests

# How to setup Database?

Make sure that MySQL is working and database is exists according to app/config/database.yml

```
mysql -u root -p
mysql>create database mydatabase;  
mysql>grant all on mydatabase.* to 'root'@'localhost';  
```

See also:
http://rubylearning.com/satishtalim/ruby_activerecord_and_mysql.html

## Migrate table

    bundle exec rake db:migrate

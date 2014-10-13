## How do I get started?

## Requirements

* [ruby](https://www.ruby-lang.org/en/) 2.1.2
* [gem](https://rubygems.org/) 2.2.2
* [bundler](http://bundler.io/) 1.7.2 +
* [ImageMagick](http://www.imagemagick.org/) 6.5.4-7


```
[vagrant@ruby src]$ ruby -v
ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-linux]
[vagrant@ruby src]$ gem -v
2.2.2
[vagrant@ruby src]$ bundle -v
Bundler version 1.7.2
[vagrant@ruby src]$ convert -v
Version: ImageMagick 6.5.4-7 2014-02-10 Q16 OpenMP http://www.imagemagick.org
Copyright: Copyright (C) 1999-2009 ImageMagick Studio LLC
```

You can use [rbenv](https://github.com/sstephenson/rbenv) to install these requirements.

```
rbenv install --list
rbenv install 2.1.2
rbenv rehash
rbenv versions
rbenv global 2.1.2
gem install bundler
```

Set up MySQL for utf8mb4
```
sudo vi /etc/my.cnf
sudo service mysqld restart
```

Install libs for gem
```
sudo yum install ImageMagick-devel mysql-devel
```

## Clone repository and install gems

```
git clone git://path/to/repo
cd path/to/server/app
bundle install --path vendor/bundle
```

# How do I start the application?

Start the app by running:

    bundle exec rake s


# How do I start the application in daemon?


    RACK_ENV=production bundle exec unicorn -c unicorn.rb -D

    # Stop
    kill -QUIT `cat unicorn.pid`

See also http://blog.designrecipe.jp/2011/07/30/unicorn/

## Helper Rake Tasks

There are a few helper Rake tasks that will help you to clear and compile your Sass stylesheets as well as a few other helpful tasks. There is also a generate task, so you can generate a new project at a defined location based on the bootstrap.

    bundle exec rake -T

    rake db:migrate  # Migrate the database
    rake generate    # Generate a new project at dir=foo
    rake routes      # List all routes for this application
    rake s           # Run the app
    rake test        # Run tests

# How to setup Database?

    bundle exec rake db:create:all
    bundle exec rake db:migrate


** Notice **
** TODO **
** FIXME **
Do not use `schema.rb.`
`schema.rb` is created by `bundle exec rake db:schema:dump`,
currently `schema.rb` does not contains whole information of schema like column comment, table options.

If you want to use `schema.rb`, make sure to add these lines.

```
execute "ALTER TABLE user_fb_friends ROW_FORMAT=DYNAMIC;"
execute "ALTER TABLE users ROW_FORMAT=DYNAMIC;"
```

See also:
http://rubylearning.com/satishtalim/ruby_activerecord_and_mysql.html

## Generate documentation

    bundle exec yardoc app --plugin yard-sinatra

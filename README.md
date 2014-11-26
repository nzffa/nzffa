# NZ Farm Forestry Association Membership Management System

This MMS uses Radiant CMS as its core. For more information on Radiant, see:
http://github.com/radiant/radiant/

Current Radiant version is: 1.0.1

[![Build Status](https://secure.travis-ci.org/enspiral/nzffa.png?branch=master)](http://travis-ci.org/enspiral/nzffa)

## License

The NZFFA website source code is released under the MIT license and is copyright (c) 2011-2014 NZFFA.

## Development Installation

1. Clone project from github at https://github.com/enspiral/nzffa
3. Fetch production data
     bundle exec rake sync
4. Create symlinks
     bundle exec rake symlink

## Running Cucumber Specs

cucumber features are in vendor/extentions/marketplace/features
run with 'bundle exec cucumber' from vendor/extentions/marketplace

## Deployment

Install capistrano and extensions on your local machine:

  gem install capistrano capistrano-ext

Deploy to staging or production server with:

```bash
cap staging deploy
```

or

```bash
cap production deploy
```


## ENSPIRAL STAGING SERVER

To access:

```bash
ssh nzffa@nzffa.enspiral.info
```

Contact Craig to get your public ssh key on that server first.

To update the staging server to match production

```bash
cd ~/staging/current
bundle exec rake sync RAILS_ENV=staging
```
##About this extension

This is the NZFFA Member Management System based on Radiant CMS.

For the complete member management system our following forked extensions are required:

radiant-nzffa_conference-extension

radiant-reader-extension

radiant-forum-extension

radiant-page_reader_group_permissions-extension

For conferences you can bolt on our radiant-nzffa_conference-extension

The code is well tested and robust. [The NZFFA website] (http://www.nzffa.org.nz) has been based on this MMS for many years.


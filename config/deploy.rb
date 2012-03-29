require "bundler/capistrano"

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "nzffa"
set :user, "nzffa"
set :group, "www-data"

set :scm, :git
set :repository, "git@github.com:enspiral/nzffa.git"
set :branch, 'master'
set :deploy_via, :remote_cache

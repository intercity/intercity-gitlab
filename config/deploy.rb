require 'bundler/capistrano'
require 'intercity/capistrano'
require 'sidekiq/capistrano'

set :application, "gitlab_production"
set :repository,  "https://github.com/gitlabhq/gitlabhq.git"
set :branch, "6-2-stable"

set :deploy_via, :remote_cache
set :scm, :git
set :user, "git"
set :bundle_without, [:development, :test, :puma, :postgres, :aws]

server "<server host>", :web, :app, :db, :primary => true

set :sidekiq_cmd, "#{try_sudo} bundle exec sidekiq -q post_receive,mailer,system_hook,project_web_hook,gitlab_shell,common,default"

after "deploy:restart", "deploy:cleanup"

after "deploy:finalize_update", "gitlab:link"

namespace :gitshell do

  task :install do
    run "cd /home/git && git clone https://github.com/gitlabhq/gitlab-shell.git"
    run "cd /home/git/gitlab-shell && git checkout v1.7.0"
    upload "gitlab-shell.yml", "/home/git/gitlab-shell/config.yml"
    run "cd /home/git/gitlab-shell && ./bin/install"
  end

end

namespace :gitlab do

  desc "Install gitshell and configure gitlab."
  task :prepare do
    gitshell.install
    gitlab.configure
  end

  desc "Upload gitlab.yml and create gitlabl satellites directory."
  task :configure do
    upload "gitlab.yml", "/u/apps/#{application}/shared/config"
    run "cd /home/git && mkdir -p gitlab-satellites"
  end

  task :link do
    run "#{try_sudo} ln -nfs #{shared_path}/config/gitlab.yml #{release_path}/config/gitlab.yml"
  end

  desc "Executes bundle exec  rake gitlab:setup."
  task :setup do
    run "cd #{current_path} && bundle exec rake gitlab:setup RAILS_ENV=production force=yes"
  end

  desc "Backs up your gitlab"
  task :backup do
    run "cd #{current_path} && bundle exec rake gitlab:backup:create RAILS_ENV=production"
  end

end

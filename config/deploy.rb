require 'bundler/capistrano'
load 'deploy/assets'

task :production do
  role :web, "node1650.speedyrails.net"
  role :app, "node1650.speedyrails.net"
  role :db,  "node1650.speedyrails.net", :primary => true
  set :application, "musicalretreat"
end

task :development do
  role :web, "node1650.speedyrails.net"
  role :app, "node1650.speedyrails.net"
  role :db,  "node1650.speedyrails.net", :primary => true
  set :application, "mmrdev"
  set :branch, "development"
end

set :repository, "git@github.com:hankssj/musicalretreat-registration.git"

ssh_options[:config] = false

set :normalize_asset_timestamps, false

set(:deploy_to) { "/var/www/apps/#{application}" }

set :user, "deploy"
set :group, "www-data"

set :deploy_via, :remote_cache
set :scm, "git"
set :keep_releases, 5

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:finalize_update", "deploy:symlink_configs" #, "deploy:symlink_custom"

namespace :deploy do

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{deploy_to}/#{shared_dir}/tmp/restart.txt"
  end

  desc "Tasks to execute after code update"
  task :symlink_configs, :roles => [:app] do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "if [ -d #{release_path}/tmp ]; then rm -rf #{release_path}/tmp; fi; ln -nfs #{deploy_to}/#{shared_dir}/tmp #{release_path}/tmp"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end

  desc "Custom Symlinks"
  task :symlink_custom, :roles => [:app] do
  end

end

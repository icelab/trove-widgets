set :application, 'trove-widgets'
set :repository,  "https://github.com/icelab/#{application}.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, 'trovespace.webfactional.com'                          # Your HTTP server, Apache/etc
role :app, 'trovespace.webfactional.com'                          # This may be the same as your `Web` server

set :deploy_to, "/home/icelab/widgets/#{application}"
set :user, 'icelab'
set :rails_env, 'production'
set :use_sudo, false
default_run_options[:pty] = true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do

  desc "Restart nginx"
  task :restart do
    run "#{deploy_to}/../bin/restart"
  end

end

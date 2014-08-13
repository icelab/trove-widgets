require 'dotenv/deployment/capistrano'

set :application, 'trove-widgets'
set :repository,  "https://github.com/icelab/#{application}.git"

set :scm, :git

role :web, 'trovespace.webfactional.com'
role :app, 'trovespace.webfactional.com'

set :deploy_to, "/home/trovespace/webapps/widgets"
set :rails_env, "production"
set :default_environment, {
  'PATH' => "#{deploy_to}/bin:$PATH",
  'GEM_HOME' => "#{deploy_to}/gems",
  "RAILS_ENV" =>  "#{rails_env}"
}

set :user, 'trovespace'
set :use_sudo, false
default_run_options[:pty] = true

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"


namespace :deploy do

  puts "===================================================\n"
  puts "         (  )   (   )  )"
  puts "      ) (   )  (  (         GO GRAB SOME COFFEE"
  puts "      ( )  (    ) )\n"
  puts "     <_____________> ___    CAPISTRANO IS ROCKING!"
  puts "     |             |/ _ \\"
  puts "     |               | | |"
  puts "     |               |_| |"
  puts "  ___|             |\\___/"
  puts " /    \\___________/    \\"
  puts " \\_____________________/ \n"
  puts "==================================================="

  #desc "Restart nginx"
  #task :restart do
  #  run "#{deploy_to}/bin/restart"
  #end

  desc "Bundle install gems"
  task :bundle do
    run "cd #{deploy_to}/current; bundle install --deployment"
  end

  namespace :assets do
    desc "Run the precompile task"
    task :precompile, roles: :web, except: {no_release: true} do
      run "ln -s #{deploy_to}/shared/NLA-stats-87ada0746583.p12 #{deploy_to}/current/config/GA.p12"
    end
  end

  desc "Server restart"
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  desc "GA key symlink"
  task :bundle do
    run "cd #{deploy_to}/current/config/GA.p12.; bundle install --deployment"
  end

end

after "deploy:create_symlink", "deploy:bundle"
after "deploy:create_symlink", "deploy:assets:precompile"
after "deploy:create_symlink", "deploy:restart"
after "deploy:create_symlink", "deploy:cleanup"

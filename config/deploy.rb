set :application, 'trove-widgets'
set :repository,  "https://github.com/icelab/#{application}.git"

set :scm, :git

role :web, 'trovespace.webfactional.com'
role :app, 'trovespace.webfactional.com'

set :deploy_to, "/home/trovespace/webapps/widgets"
set :default_stage, "production"
set :default_environment, {
  'PATH' => "#{deploy_to}/bin:$PATH",
  'GEM_HOME' => "#{deploy_to}/gems",
  "RAILS_ENV" =>  "#{default_stage}"
}

set :user, 'trovespace'
set :rails_env, 'production'
set :use_sudo, false
default_run_options[:pty] = true

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

  desc "Restart nginx"
  task :restart do
    run "#{deploy_to}/bin/restart"
  end

  desc "Bundle install gems"
  task :bundle do
    run "cd #{deploy_to}/current; bundle install --deployment"
  end

  namespace :assets do
    desc "Run the precompile task remotely"
    task :precompile, roles: :web, except: {no_release: true} do
      run "cd #{deploy_to}/current; bundle exec rake assets:precompile RAILS_ENV=#{default_stage}"
    end
  end

end

#after "deploy", "deploy:bundle"
after "deploy", "deploy:assets:precompile"
after "deploy", "deploy:cleanup"
after "deploy", "deploy:restart"

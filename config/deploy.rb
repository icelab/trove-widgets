set :application, 'trove-widgets'
set :repository,  "https://github.com/icelab/#{application}.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, 'trovespace.webfactional.com'                          # Your HTTP server, Apache/etc
role :app, 'trovespace.webfactional.com'                          # This may be the same as your `Web` server

set :deploy_to, "/home/trovespace/webapps/widgets"
set :default_stage, "production"
set :default_environment, {
  'PATH' => "#{deploy_to}/bin:$PATH",
  'GEM_HOME' => "#{deploy_to}/gems"
}


set :user, 'trovespace'
set :rails_env, 'production'
set :use_sudo, false
default_run_options[:pty] = true

namespace :deploy do

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
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run "cd #{deploy_to}/current; bundle exec rake assets:precompile RAILS_ENV=#{default_stage}"
    end
  end

end

after "deploy", "deploy:bundle"
after "deploy", "deploy:assets:precompile"
after "deploy", "deploy:cleanup"
after "deploy", "deploy:restart"

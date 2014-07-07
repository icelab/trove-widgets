namespace :trove do

  task :import_titles => :environment  do
    Title.sync
  end

end

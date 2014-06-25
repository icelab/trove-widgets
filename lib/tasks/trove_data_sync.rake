namespace :trove_data_sync do

  task :import_titles => :environment  do
    State.sync_titles
  end

  task :import_counters => :environment  do
    Title.sync_counters
  end

end

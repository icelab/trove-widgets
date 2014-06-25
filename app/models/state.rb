class State < ActiveRecord::Base

  self.primary_key = :abbrev
  has_many :titles, foreign_key: :state_abbrev, class_name: Title

  def self.import_all_titles
    State.all.each do |state|
      state.import_titles
    end
  end

  def import_titles
    # Get Trove API titles count
    trove_api_titles = Trove::Client.new(key: ENV['TROVE_API_KEY']).titles_by_state(self.abbrev)
    # Update state titles if local titles count is less than Trove API titles count
    if self.titles.size < trove_api_titles.total.to_i
      # Get difference between local titles and Trove API titles
      new_titles = trove_api_titles.newspaper.reject{|trove_title| self.titles.pluck(:trove_id).include?(trove_title.id.to_i) }
      # Add each new title to local titles storage
      new_titles.each do |paper|
        self.titles.create(trove_id: paper.id, start_date: paper.startDate, end_date: paper.endDate, name: paper.title, trove_url: paper.troveUrl)
      end
    end
  end

end

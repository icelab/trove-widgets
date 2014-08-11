class Widgets::UsageController < ApplicationController

  layout false

  def pageviews
    # Get state
    state = State.new.find_by_abbrev(params[:state])
    @state = state.name
    # Receive all title ids from GA
    top_titles = set_cache(['usage_pageviews', caching_params([])]) {GoogleApi.new.top_titles(Title.new.items.size)}
    # Merge state titles with GA stats
    @newspapers = top_titles.inject([]) do |memo, title|
      # If current title id and GA title id are equal
      state_titles = state.titles.detect{|metric| metric.id == title.id}
      # Merge loca title data and GA stats
      memo << title.merge(state_titles) if state_titles.present?
      memo
    end
  end

end

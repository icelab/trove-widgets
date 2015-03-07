class Widgets::UsageController < ApplicationController

  layout false

  def state
    # Get state
    state  = State.new.find_by_abbrev(params[:state])
    @state = state.name

    begin
      # Receive all title ids from GA
      top_titles = set_cache(["usage_state", caching_params(params)]) {GoogleApi.new.top_titles(Title.new.items.size)}
      # Merge state titles with GA stats
      @newspapers = top_titles.inject([]) do |memo, title|
        # If current title id and GA title id are equal
        state_titles = state.titles.detect{|metric| metric.id == title.id}
        # Merge loca title data and GA stats
        memo << title.merge(state_titles) if state_titles.present?
        memo
      end
    rescue => e
      render text: e.message
    end
  end

  def single
    get_paper [params[:ids]]
  end

  def multiple
    get_paper params[:ids].split(",")
  end

private

  def get_paper(ids)
    titles = Title.new.items.select{|title| ids.include? title.id}
    stats  = set_cache(['usage_titles', caching_params(params)]) {GoogleApi.new.title_stats(ids)}
    @newspapers = titles.map {|title|
      title_stats = stats.detect{|stat_title| stat_title.id == title.id}
      title['pageviews'] = title_stats.pageviews
      title['visitors']  = title_stats.visitors
      title['sessions']  = title_stats.sessions
      title
    }
  end

end

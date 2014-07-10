class Widgets::SummaryController < ApplicationController

  layout false

  def state
    response = set_cache(['summary_state', caching_params(params)]) {TroveApi.new.state(params[:state])}
    @state = State.new.find_by_abbrev(response[:state]).name
    @newspapers = response[:titles]
    @issuecount = response[:total]
    @start_date = @newspapers.map(&:start_date).min
    @end_date = @newspapers.map(&:end_date).max
  end

  def single
    @newspapers = set_cache(['summary_single', caching_params(params)]) {TroveApi.new.single_include_years(params[:ids])}
  end

  def multiple
    @newspapers = set_cache(['summary_multiple', caching_params(params)]) {TroveApi.new.multiple_include_years(params[:ids])}
  end

  def statesearch
    @state = State.new.find_by_abbrev(params[:state]).name
    @newspapers = set_cache(['summary_statesearch', caching_params(params)]) {TroveApi.new.multiple_include_years(params[:ids])}
  end

end

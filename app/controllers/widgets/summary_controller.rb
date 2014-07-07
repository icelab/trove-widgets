class Widgets::SummaryController < ApplicationController

  layout 'widgets'

  def single
    @newspapers = set_cache(['summary_single', caching_params(params)]) {TroveApi.new.single_include_years(params[:ids])}
  end

  def multiple
    @newspapers = set_cache(['summary_multiple', caching_params(params)]) {TroveApi.new.multiple_include_years(params[:ids])}
  end

  def state
    response = set_cache(['summary_state', caching_params(params)]) {TroveApi.new.state(params[:state])}
    @state = State.new.find_by_abbrev(response[:state]).name
    @newspapers = response[:titles]
    @issuecount = response[:total]
    @start_date = @newspapers.map{|item| item[:start_date]}.min
    @end_date = @newspapers.map{|item| item[:end_date]}.max
  end

  def statesearch
    @newspapers = set_cache(['summary_statesearch', caching_params(params)]) {TroveApi.new.multiple_include_years(params[:ids])}
    @state = State.new.find_by_abbrev(params[:state]).name
  end

end

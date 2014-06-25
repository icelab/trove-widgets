class Widgets::SummaryController < ApplicationController

  layout 'widgets'

  def single
    @newspapers = set_cache(['summary_single', params]) {TroveApi.new.single_include_years(params[:ids])}
  end

  def multiple
    @newspapers = set_cache(['summary_multiple', params]) {TroveApi.new.multiple_include_years(params[:ids])}
  end

  def state
    response = set_cache(['summary_state', params]) {TroveApi.new.state(params[:state])}
    @state = params[:state].upcase
    @newspapers = response[:titles]
    @issuecount = response[:total]
    @start_date = @newspapers.map{|item| item[:start_date]}.min
    @end_date = @newspapers.map{|item| item[:end_date]}.max
  end

end

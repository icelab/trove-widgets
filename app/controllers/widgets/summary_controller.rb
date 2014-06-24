class Widgets::SummaryController < ApplicationController

  layout 'widgets'

  def single
    @newspapers = Rails.cache.fetch(['summary_single', params], expires: 1.day) {TroveApi.new.single_include_years(params[:ids])}
  end

  def multiple
    @newspapers = Rails.cache.fetch(['summary_multiple', params], expires: 1.day) {TroveApi.new.multiple_include_years(params[:ids])}
  end

  def state
    response = Rails.cache.fetch(['summary_state', params], expires: 1.day) {TroveApi.new.state(params[:state])}
    @state = params[:state].upcase
    @newspapers = response[:titles]
    @issuecount = response[:total]
    dates = @newspapers.map{|item| item[:start_date]}
    @start_date = dates.min
    @end_date = dates.max
  end

end

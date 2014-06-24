class Widgets::SummaryController < ApplicationController

  layout 'widgets'

  def single
    @newspapers = TroveApi.new.single_include_years(params[:ids])
  end

  def multiple
    @newspapers = TroveApi.new.multiple_include_years(params[:ids])
  end

  def state
    response = TroveApi.new.state(params[:state])
    @state = params[:state].upcase
    @newspapers = response[:titles]
    @issuecount = response[:total]
    dates = @newspapers.map{|item| item[:start_date]}
    @start_date = dates.min
    @end_date = dates.max
  end

end

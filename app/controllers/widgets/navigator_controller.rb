class Widgets::NavigatorController < ApplicationController

  layout 'widgets'

  def title
    response = set_cache(['navigator_title', params]) {TroveApi.new.state(params[:state])}
    @state = params[:state].upcase
    @newspapers = response[:titles]
    @issuecount = response[:total]
    dates = @newspapers.map{|item| item[:start_date]}
    @start_date = dates.min
    @end_date = dates.max
  end

end

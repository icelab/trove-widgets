class Widgets::NavigatorController < ApplicationController

  layout 'widgets'

  def title
    response = set_cache(['navigator_title', params]) {TroveApi.new.state(params[:state])}
    @state = params[:state].upcase
    @newspapers = response[:titles]
    @issuecount = response[:total]
    @start_date = @newspapers.map{|item| item.start_date}.min
    @end_date = @newspapers.map{|item| item.end_date}.max
  end

end

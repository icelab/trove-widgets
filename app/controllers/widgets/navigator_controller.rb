class Widgets::NavigatorController < ApplicationController

  layout false

  def title
    response = set_cache(['navigator_title', caching_params(params)]) {TroveApi.new.state(params[:state])}
    @state = State.new.find_by_abbrev(response[:state]).name
    @newspapers = response[:titles]
    @issuecount = response[:total]
    @start_date = @newspapers.map{|item| item.start_date}.min
    @end_date = @newspapers.map{|item| item.end_date}.max
  end

end

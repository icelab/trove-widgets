class Widgets::NavigatorController < ApplicationController

  layout false

  def title
    response = set_cache(['navigator_title', caching_params(params)]) {TroveApi.new.state(params[:state])}
    @state = State.new.find_by_abbrev(response[:state]).name
    @newspapers = response[:titles]
    @issuecount = response[:total]
    @start_date = @newspapers.map(&:start_date).delete_if{|value| value == '0'}.min
    @end_date = @newspapers.map(&:end_date).delete_if{|value| value == '0'}.max
  end

end

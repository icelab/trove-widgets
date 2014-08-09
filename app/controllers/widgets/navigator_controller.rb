class Widgets::NavigatorController < ApplicationController

  layout false

  def title
    state = State.new.find_by_abbrev(params[:state])
    @state = state.name
    @newspapers = state.titles
    @issuecount = @newspapers.size
    @start_date = @newspapers.map(&:start_year).delete_if{|value| value == '0'}.min
    @end_date = @newspapers.map(&:end_year).delete_if{|value| value == '0'}.max
  end

end

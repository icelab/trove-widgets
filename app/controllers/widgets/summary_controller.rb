class Widgets::SummaryController < ApplicationController

  layout 'widgets'

  def single
    @newspapers = set_cache(['summary_single', params]) {TroveApi.new.single_include_years(params[:ids])}
  end

  def multiple
    @newspapers = set_cache(['summary_multiple', params]) {TroveApi.new.multiple_include_years(params[:ids])}
  end

end

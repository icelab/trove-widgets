class Widgets::UsageController < ApplicationController

  layout false

  def pageviews
    @pageviews = set_cache(['navigator_title', caching_params(params)]) {GoogleApi.new.pageviews}
  end

end

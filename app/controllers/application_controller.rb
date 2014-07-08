class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :allow_iframe_requests

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

  def caching_params(params)
    params.select{|param| %w(view type state ids).include?(param)}
  end

  def set_cache(id, &block)
    Rails.cache.fetch(id, expires: 1.day) do
      block.call
    end
  end

end

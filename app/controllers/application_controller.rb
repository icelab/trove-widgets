class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_cache(id, &block)
    Rails.cache.fetch(id, expires: 1.day) do
      block.call
    end
  end

end

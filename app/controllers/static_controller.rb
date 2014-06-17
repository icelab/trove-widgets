class StaticController < ApplicationController

  def widgets
    respond_to do |format|
      format.js
    end
  end

end

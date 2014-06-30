class StaticController < ApplicationController

  def index
    @states = State.order('name ASC')
    @titles = Title.order('name ASC')
  end

end

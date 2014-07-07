class StaticController < ApplicationController

  def index
    @states = State.all.sorted
    @titles = Title.order('name ASC')
  end

end

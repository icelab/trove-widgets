class StaticController < ApplicationController

  def index
    @states = State.new.sorted
    @titles = Title.new.sorted
  end

end

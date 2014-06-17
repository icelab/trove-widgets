module ApplicationHelper

  def data_params
    params.except(:controller)
  end

end

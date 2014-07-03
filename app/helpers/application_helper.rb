module ApplicationHelper

  def data_params
    params.except(:controller).merge({root: root_path})
  end

  def human_counts(word, count)
    "#{number_to_human(count, format: '%n%u', units: {thousand: 'K', million: 'M'})} #{word.pluralize(count)}"
  end

end

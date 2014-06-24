module ApplicationHelper

  def data_params
    params.except(:controller)
  end

  def human_counts(word, count)
    "#{number_to_human(count, format: '%n%u', units: {thousand: 'K'})} #{word.pluralize(count)}"
  end

end

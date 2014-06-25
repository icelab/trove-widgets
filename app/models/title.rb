class Title < ActiveRecord::Base

  self.primary_key = :trove_id
  belongs_to :state, class_name: State

end

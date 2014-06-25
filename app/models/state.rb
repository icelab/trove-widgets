class State < ActiveRecord::Base

  self.primary_key = :abbrev
  has_many :titles, foreign_key: :state_abbrev, class_name: Title

end

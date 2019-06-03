class ContentModule < ApplicationRecord
  belongs_to :session
  acts_as_list scope: :session
  belongs_to :intel1, class_name: "Intelligence", foreign_key: 'intel1_id'
  belongs_to :intel2, class_name: "Intelligence", foreign_key: 'intel2_id'
end

class ContentModule < ApplicationRecord
  belongs_to :content
  belongs_to :action1, class_name: "Action", foreign_key: 'action1_id'
  belongs_to :action2, class_name: "Action", foreign_key: 'action2_id', optional: true
  acts_as_list scope: :content
end

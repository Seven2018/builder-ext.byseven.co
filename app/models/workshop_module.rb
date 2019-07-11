class WorkshopModule < ApplicationRecord
  belongs_to :workshop
  belongs_to :user, optional: true
  belongs_to :action1, class_name: "Action", foreign_key: 'action1_id'
  belongs_to :action2, class_name: "Action", foreign_key: 'action2_id', optional: true
  acts_as_list scope: :workshop
end
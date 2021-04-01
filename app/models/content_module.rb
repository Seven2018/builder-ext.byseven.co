class ContentModule < ApplicationRecord
  belongs_to :content
  belongs_to :action1, class_name: "Action", foreign_key: 'action1_id', optional: true
  belongs_to :action2, class_name: "Action", foreign_key: 'action2_id', optional: true
  validates :title, :duration, presence: true
  acts_as_list scope: :content
  has_rich_text :instructions
end

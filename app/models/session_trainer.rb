class SessionTrainer < ApplicationRecord
  belongs_to :user
  belongs_to :session
  belongs_to :invoice_item, optional: true
  validates_uniqueness_of :session_id, scope: :user_id
  self.inheritance_column = :_type_disabled

  def initials
    "#{self.user.firstname.first.upcase}#{self.user.lastname.first.upcase}"
  end
end

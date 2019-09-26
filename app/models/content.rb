class Content < ApplicationRecord
  belongs_to :theme, optional: true
  has_many :theory_contents, :dependent => :destroy
  has_many :theories, through: :theory_contents
  has_many :content_modules, :dependent => :destroy
  validates :title, presence: true, allow_blank: false
  before_save :default_values

  private

  def default_values
    self.duration ||= 0 if self.duration.nil?
  end
end

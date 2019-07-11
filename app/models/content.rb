class Content < ApplicationRecord
  # has_many :intelligence_contents, :dependent => :destroy
  # has_many :intelligence, through: :intelligence_contents
  belongs_to :theme, optional: true
  has_many :theory_contents, :dependent => :destroy
  has_many :theories, through: :theory_contents
  has_many :content_modules, :dependent => :destroy
  validates :title, :description, presence: true, allow_blank: false
  # validates :theme, inclusion: { in: ["Leadership", "Gestion d'équipe", "Communication", "Business Development", "Gestion de Projet", "Intelligence Economique", "Team Building"] }
end

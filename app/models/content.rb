class Content < ApplicationRecord
  # has_many :intelligence_contents, :dependent => :destroy
  # has_many :intelligence, through: :intelligence_contents
  belongs_to :intel1, class_name: "Intelligence", foreign_key: 'intel1_id'
  belongs_to :intel2, class_name: "Intelligence", foreign_key: 'intel2_id'
  has_many :theory_contents, :dependent => :destroy
  has_many :theories, through: :theory_contents
  validates :title, :format, :duration, :description, :chapter, presence: true, allow_blank: false
  validates :chapter, inclusion: { in: ["Leadership", "Gestion d'équipe", "Communication", "Business Development", "Gestion de Projet", "Intelligence Economique", "Team Building"] }

  def intelligences
    [intel1, intel2]
  end
end

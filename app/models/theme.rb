class Theme < ApplicationRecord
  extend ActsAsTree::TreeView
  extend ActsAsTree::TreeWalker
  has_many :contents
  has_many :workshops
  has_many :merchandises
  validates :name, presence: true
  acts_as_tree order: "name"
end

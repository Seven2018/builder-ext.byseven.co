class Theme < ApplicationRecord
  extend ActsAsTree::TreeView
  extend ActsAsTree::TreeWalker
  has_many :contents
  has_many :workshops
  validates :name, presence: true
  acts_as_tree order: "name"
end

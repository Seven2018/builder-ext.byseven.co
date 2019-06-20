class Chapter < ApplicationRecord
  extend ActsAsTree::TreeView
  extend ActsAsTree::TreeWalker
  has_many :contents
  validates :name, presence: true
  acts_as_tree order: "name"
end

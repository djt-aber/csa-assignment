class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many :replies, dependent: :destroy
  validates_presence_of :title, :body
  self.per_page = 8
end

class Reply < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :reply, optional: true
  belongs_to :post
  has_many :replies, class_name: "Reply", foreign_key: "reply_id", dependent: :destroy
end

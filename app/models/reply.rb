class Reply < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :reply, optional: true
  belongs_to :post
  has_many :replies, class_name: "Reply", foreign_key: "reply_id", dependent: :destroy

  validate :text_editor_blank
    
  #adds extra validation so that CKEditor form can't be submitted without actual text  
  def text_editor_blank
    if body == "<p>&nbsp;</p>" 
      errors.add(:body, "can't be blank")
    end
  end
end

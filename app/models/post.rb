class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many :replies, dependent: :destroy
  validates_presence_of :title, :body
  self.per_page = 8

  validate :text_editor_blank
  
  #adds extra validation so that CKEditor form can't be submitted without actual text  
  def text_editor_blank
    if body == "<p>&nbsp;</p>" 
      errors.add(:body, "can't be blank")
    end
  end

end

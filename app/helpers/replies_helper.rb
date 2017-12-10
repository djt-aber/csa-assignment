module RepliesHelper
  #returns the title of the parent reply, used for the default title in the forms
  def getParentReplyTitle(id)
    return Reply.find(id).title
  end

  #returns the title of the parent post, used for the default title in the forms.
  def getParentPostTitle(id)
    return Post.find(id).title
  end
end

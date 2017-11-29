module RepliesHelper
  def getParentReplyTitle(id)
    return Reply.find(id).title
  end

  def getParentPostTitle(id)
    return Post.find(id).title
  end
end

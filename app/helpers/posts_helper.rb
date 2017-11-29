module PostsHelper
  $replies = Array.new
  $count = 1 
  
  def getReplies(post)
    post.replies.each do |reply|
      $count += 1
      $replies.push([reply, $count])
      getReplies(reply)
      $count -= 1
    end
    return $replies 
  end

  def clearVars
    $replies = Array.new
    $count = 1
  end

  def checkPosts(post, currentUser)
    if (!UserPostTime.select(:created_at).where(user_id: currentUser, post_id: post.id).any?)
      return post.replies.count+1   
    else
      unreadPosts = 0
      lastTime = UserPostTime.select(:created_at).where(user_id: currentUser, post_id: post.id).first.created_at
      #first check for time of post created
      #replyCount = Post.count(:all).where(post_id: post.id).where("created_at > ?", lastTime)
      replyCount = Reply.where(post_id: post.id).where("created_at > ?", lastTime).count
      #then count replies which timestamps are after
      #add the two together
    end
  end

  def readPost(post, currentUser)
    userPost = UserPostTime.find_or_initialize_by(user_id: currentUser, post_id: post.id)
    userPost.created_at = DateTime.now
    userPost.save!
  end

end

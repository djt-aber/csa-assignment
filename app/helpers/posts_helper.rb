module PostsHelper
  $replies = Array.new
  $count = 1 
 
  #recursive function to go through each reply and it's own replies and returns them in the appropraite order. 
  def getReplies(post)
    post.replies.each do |reply|
      $count += 1
      $replies.push([reply, $count])
      #recursively calls itself with the child reply
      getReplies(reply)
      $count -= 1
    end
    return $replies 
  end

  #clears the global variables
  def clearVars
    $replies = Array.new
    $count = 1
  end

  #this is called in the posts index for each post
  def checkPosts(post, currentUser)
	  # checks to see whether the user has read the post
    if (!UserPostTime.select(:created_at).where(user_id: currentUser, post_id: post.id).any?)
      return post.replies.count+1   
    else
      unreadPosts = 0
      lastTime = UserPostTime.select(:created_at).where(user_id: currentUser, post_id: post.id).first.created_at
      replyCount = Reply.where(post_id: post.id).where("created_at > ?", lastTime).count
    end
  end

  #this is called when the user reads looks at a post
  def readPost(post, currentUser)
    #adds an extra view to the view counter for the post
    post.views += 1
    post.save

    #looks for an existing time record for the user and post, if one doesn't exist it creates one, if it already exists, it updates the current time to now.
    userPost = UserPostTime.find_or_initialize_by(user_id: currentUser, post_id: post.id)
    userPost.created_at = DateTime.now
    userPost.save!
  end

end

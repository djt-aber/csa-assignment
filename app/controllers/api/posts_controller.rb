# Handles incoming user account HTTP JSON web service requests
# @author Chris Loftus
class API::PostsController < API::ApplicationController
  skip_before_action :verify_authenticity_token
	before_action :set_post, only: [:show, :destroy]

  # GET /api/users.json
  def index
    # If the REST client wants everything using the all query
    # parameter, then give it everything!
    if params.key?(:all)
      @posts = Post.all.order('created_at DESC')
    else
      @posts = Post.paginate(page: params[:page],
			   per_page: params[:per_page])
                 .order('created_at DESC')
    end
    
  end

  # GET /api/users/1.json
  def show
    respond_to do |format|
      format.json
    end
  end

  # POST /api/users.json
  def create
    respond_to do |format|
      format.json do
        @post = Post.new(post_params)

        if @post.save # Will attempt to save user and image
          head :created, location: api_post_url(@post)
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /api/users/1.json
  def destroy
    respond_to do |format|
      format.json do
        @post.destroy
        head :no_content
      end
    end
  end

  private
  def post_params
	  params.require(:post).permit(:title, :body, :user_id, :anonymous)
  end

  def set_post
      @post = Post.find(params[:id])
    end


end

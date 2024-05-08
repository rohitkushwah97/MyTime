class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    posts = Post.where(status: "universal")
    user = User.joins("INNER JOIN my_phone_books ON users.phone_number = my_phone_books.contact_number").where("users.phone_number != ?", current_user.phone_number)
    contacts_posts = user.includes(:posts).where(posts: { status: 'contacts' }).map(&:posts).flatten
    final_posts = posts + contacts_posts
    render json: { data: ActiveModelSerializers::SerializableResource.new(final_posts, each_serializer: PostSerializer) }, status: :ok
  end

  def current_user_posts
    posts = current_user.posts
    render json: { data: PostSerializer.new(posts) }, status: :ok
  end

  def show
    render json: { data: PostSerializer.new(@post) }, status: :ok
  end

  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))
    User.where(phone_number: current_user.my_phone_books.pluck(:contact_number)).where.not(phone_number: current_user.phone_number)


    if @post.save
      render json: { data: PostSerializer.new(@post), message: 'Post created successfully' }, status: :created
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: { data: PostSerializer.new(@post), message: 'Post updated successfully' }, status: :ok
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      render json: { message: 'Post successfully deleted' }, status: :ok
    else
      render json: { errors: 'Failed to delete post' }, status: :unprocessable_entity
    end
  end


  private
    def set_post
      @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Post not found' }, status: :not_found
    end

    def post_params
      params.require(:data).permit(:caption, :status, :category_id, :user_id, images: [])
    end
end


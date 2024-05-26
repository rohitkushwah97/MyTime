class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    user_address = current_user.address
    posts = Post.where(status: "universal")
    user = User.joins("INNER JOIN my_phone_books ON users.phone_number = my_phone_books.contact_number").where("users.phone_number != ?", current_user.phone_number)
    contacts_posts = user.includes(:posts).where(posts: { status: 'contacts' }).map(&:posts).flatten
    all_posts = posts

    if params[:category_id].present?
      category_posts = all_posts.where(category_id: params[:category_id])
      if user_address.present? && user_address.latitude.present? && user_address.longitude.present?
        nearby_category_posts = category_posts.sort_by do |post|
          post.distance_to_user_address(user_address)
        end
        render json: { data: ActiveModelSerializers::SerializableResource.new(nearby_category_posts, each_serializer: PostSerializer) }, status: :ok
      else
        category_posts_sorted = category_posts.sort_by(&:created_at).reverse
        render json: { data: ActiveModelSerializers::SerializableResource.new(category_posts_sorted, each_serializer: PostSerializer) }, status: :ok
      end
    else
      if user_address.present? && user_address.latitude.present? && user_address.longitude.present?
        nearby_posts = all_posts.sort_by do |post|
          post.distance_to_user_address(user_address)
        end
        render json: { contacts_posts: ActiveModelSerializers::SerializableResource.new(contacts_posts, each_serializer: PostSerializer), near_me_public_posts: ActiveModelSerializers::SerializableResource.new(nearby_posts, each_serializer: PostSerializer) }, status: :ok
      else
        all_posts_sorted = all_posts.sort_by(&:created_at).reverse
        render json: { contacts_posts: ActiveModelSerializers::SerializableResource.new(contacts_posts&.sort_by(&:created_at)&.reverse, each_serializer: PostSerializer), near_me_public_posts: ActiveModelSerializers::SerializableResource.new(all_posts_sorted, each_serializer: PostSerializer) }, status: :ok
      end
    end
  end

  def current_user_posts
    posts = current_user.posts
    render json: { data: PostSerializer.new(posts) }, status: :ok
  end

  def show
    unless current_user.posts.include?(@post)
      Notification.create(created_by: current_user,created_for: @post&.user,title: "#{current_user.full_name} has viewed your post",body: "Your post titled \"#{@post.caption}\" has been viewed.")
      @post.update_columns(view_count: @post.view_count.to_i + 1)
    end
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
  
  def search
    query = params[:data][:query]
    @posts = Post.search(query)
    render json: { data: ActiveModelSerializers::SerializableResource.new(@posts, each_serializer: PostSerializer) }, status: :ok
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


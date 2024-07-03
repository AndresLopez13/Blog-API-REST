class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]
  before_action :authorize_author!, only: %i[create update]
  before_action :authorize_admin!, only: [:destroy]

  # GET /posts
  def index
    @posts = Post.all
    render json: @posts
  end

  # GET /posts/:id
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = User.find(params[:user_id])

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:id
  def update
    @post.user = User.find(params[:user_id])

    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def authorize_author!
    user = User.find(params[:user_id])
    render json: { error: 'Not Authorized' }, status: :forbidden unless user.author?
  end

  def authorize_admin!
    user = User.find(params[:user_id])
    render json: { error: 'Not Authorized' }, status: :forbidden unless user.admin?
  end
end

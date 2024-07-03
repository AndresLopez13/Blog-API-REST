class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:destroy]
  before_action :authorize_lector!, only: [:create]
  before_action :check_comment_limit, only: [:create]

  # GET /posts/:post_id/comments
  def index
    @comments = @post.comments
    render json: @comments
  end

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = User.find(params[:user_id])

    if @comment.save
      render json: @comment, status: :created, location: post_comments_path(@post, @comment)
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:post_id/comments/:id
  def destroy
    @comment.destroy
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_lector!
    user = User.find(params[:user_id])
    render json: { error: 'Not Authorized' }, status: :forbidden unless user.lector?
  end

  def check_comment_limit
    user = User.find(params[:user_id])
    max_comments_per_day = user.daily_comment_limit
    comments_today = @post.comments.where(user:,
                                          created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count

    return unless comments_today >= max_comments_per_day

    render json: { error: 'Comment limit reached for today' }, status: :forbidden
  end
end

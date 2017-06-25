class BlogPostsController < ApplicationController
  before_action :set_blog_post, only: [:update, :show, :edit, :destroy, :toggle_is_published]
  before_action :can_make_changes, only: [:categories, :new, :destroy, :toggle_is_published]
  layout 'page_part'

  # GET /blog_posts
  def index
    @blog_posts = if !params[:category].blank?
                    BlogPostCategory.find_by_name(params[:category]).blog_posts
                      .where_is_published(current_user.try(:is_inex_office?)).order(updated_at: :desc)
                  else
                    BlogPost.includes(:blog_post_category)
                      .where_is_published(current_user.try(:is_inex_office?)).order(updated_at: :desc)
                  end
  end

  # GET/POST
  def categories
    @categories = BlogPostCategory.order(name: :asc)
    unless params[:commit].blank?
      BlogPostCategory.where(id: params['remove']).destroy_all
      @categories.each do |category|
        selected = params[category.id.to_s]
        category.update(name: selected[0], color: selected[1]) unless selected.blank?
      end
      params['new'].to_a.each do |name|
        BlogPostCategory.create(name: name) unless name.blank?
      end
      redirect_to blog_posts_path, success: "#{t :categories} #{define_notice('m', :update)}"
    end
  end

  # GET /blog_posts/1
  def show
    @recommender = Recommender.find_or_create_by(blog_post: @blog_post)
  end

  # GET /blog_posts/new
  def new
    category   = BlogPostCategory.find_by_name(params[:category])
    @blog_post = BlogPost.new(title:        t(:new_article), perex: t(:new_article_perex),
                              text:         t(:new_article_text),
                              is_published: false, blog_post_category: category)
  end

  # PATCH/PUT /blog_posts/1
  def create
    @blog_post = BlogPost.new(blog_post_params)

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to @blog_post, success: "Blog #{define_notice('m', __method__)}" }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /blog_posts/1
  def update
    respond_to do |format|
      if @blog_post.update(blog_post_params)
        format.html { redirect_to @blog_post, success: "Blog #{define_notice('m', __method__)}" }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /blog_posts/1
  def destroy
    @blog_post.destroy
    respond_to do |format|
      format.html { redirect_to blog_posts_url, success: "Blog #{define_notice('m', __method__)}" }
    end
  end

  # PUT
  def toggle_is_published
    @blog_post.update(is_published: !@blog_post.is_published)
    redirect_to :back, success: t(:blog_visibility_was_changed)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
  end

  def can_make_changes
    if !current_user || (current_user && !current_user.is_inex_office?)
      redirect_to root_path, error: t(:you_dont_have_permissions_to_perform_this_action)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def blog_post_params
    params.require(:blog_post).permit(:title, :perex, :text, :is_published, :blog_post_category_id, :image)
  end
end

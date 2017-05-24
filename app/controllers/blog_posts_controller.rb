class BlogPostsController < ApplicationController
  # index, categories, show, new, destroy, toggle_is_published, mercury_update
  before_action :set_blog_post, only: [:update, :show, :edit, :destroy, :toggle_is_published, :mercury_update]
  before_action :set_blog_post_category, only: [:show, :destroy]
  before_action :can_make_changes, only: [:categories, :new, :destroy, :toggle_is_published, :mercury_update]
  layout 'page_part'

  # GET /blog_posts
  # GET /blog_posts.json
  def index
    if current_user && current_user.is_inex_member?
      @blog_posts = BlogPost.all.order(updated_at: :desc)
    else
      @blog_posts = BlogPost.where(is_published: true).order(updated_at: :desc)
    end
    unless params[:category].blank?
      @category = BlogPostCategory.find_by_name(params[:category])
      @blog_posts = @blog_posts.where(blog_post_category: @category)
    end
  end

  # GET/POST
  def categories
    @categories = BlogPostCategory.order(name: :asc)
    unless params[:commit].blank?
      unless params['remove'].blank?
        BlogPostCategory.where(id: params['remove']).destroy_all
      end
      @categories.each do |category|
        unless params[category.id.to_s].blank?
          if category.name != params[category.id.to_s][0] || category.color != params[category.id.to_s][1]
            category.name = params[category.id.to_s][0]
            category.color = params[category.id.to_s][1]
            category.save
          end
        end
      end
      unless params['new'].blank?
        params['new'].each do |name|
          BlogPostCategory.create(name: name) unless name.blank?
        end
      end
      redirect_to blog_posts_path, success: "#{t :categories} #{define_notice('m', :update)}"
    end
  end

  # GET /blog_posts/1
  # GET /blog_posts/1.json
  def show
    Recommender.create(blog_post: @blog_post) if !@blog_post.recommender
    @recommender = @blog_post.recommender
  end

  # GET /blog_posts/new
  def new
    category = BlogPostCategory.find_by_name(params[:category])
    @blog_post = BlogPost.new(title: t(:new_article), perex: t(:new_article_perex),
                              text: t(:new_article_text),
                              is_published: false, blog_post_category: category)
  end

  def edit
  end

  # PATCH/PUT /blog_posts/1
  # PATCH/PUT /blog_posts/1.json
  def create
    @blog_post = BlogPost.new(blog_post_params)

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to @blog_post, success: "Blog #{define_notice('m', __method__)}" }
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { render :new }
        format.json { render json: @contact_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog_posts/1
  # PATCH/PUT /blog_posts/1.json
  def update
    respond_to do |format|
      if @blog_post.update(blog_post_params)
        format.html { redirect_to @blog_post, success: "Blog #{define_notice('m', __method__)}" }
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { render :edit }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_posts/1
  # DELETE /blog_posts/1.json
  def destroy
    @blog_post.destroy
    respond_to do |format|
      format.html { redirect_to blog_posts_url, success: "Blog #{define_notice('m', __method__)}" }
      format.json { head :no_content }
    end
  end

  # PUT
  def toggle_is_published
    @blog_post.update(is_published: !@blog_post.is_published)
    redirect_to :back, success: t(:blog_visibility_was_changed)
  end

  # POST
  def mercury_update
    post_params = {
      title: params[:content][:title][:value],
      perex: params[:content][:perex][:value],
      text: params[:content][:text][:value]
    }
    @blog_post.update(post_params)
    render text: ''
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
  end

  def set_blog_post_category
    @blog_post_category = @blog_post.blog_post_category_id
  end

  def can_make_changes
    if !current_user || (current_user && !current_user.is_inex_member?)
      redirect_to root_path, error: t(:you_dont_have_permissions_to_perform_this_action)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def blog_post_params
    params.require(:blog_post).permit(:title, :perex, :text, :is_published, :blog_post_category_id, :image)
  end
end

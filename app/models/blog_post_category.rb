class BlogPostCategory < ActiveRecord::Base
  has_many :blog_posts, dependent: :nullify # do not destroy
end

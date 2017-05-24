class Recommender < ActiveRecord::Base
  belongs_to :html_article
  belongs_to :blog_post

  has_many :recommendation_results
end

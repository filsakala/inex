module HtmlArticlesHelper

  def show_or_url(article)
    if article.url.blank?
      html_article_path(article)
    else
      article.url
    end
  end
end

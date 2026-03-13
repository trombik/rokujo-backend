# displays site_name.
class SitesController < ApplicationController
  before_action :set_site_name_and_ensure_presence, except: [:index, :index_without_site_name]

  def index
    @sites = Article.group(:site_name).order(count_all: :desc).count.to_a
    @sites.map! do |site|
      {
        name: site[0],
        count: site[1],
        collection: ArticleCollection.find_by(key: "site_name", value: site[0])
      }
    end
    @n_articles_without_site_name = Article.without_site_name.count
  end

  def index_without_site_name
    @pagy, @articles_without_site_name = pagy(:countish,
                                              Article.without_site_name.order(:normalized_url),
                                              items: 20)
  end

  def show
    @collection = ArticleCollection.find_by(key: "site_name", value: @site_name)
  end

  def destroy
    articles = Article.where(site_name: @site_name)
    collections = ArticleCollection.where(key: "site_name", value: @site_name)
    logger.info { articles.size }
    collections.destroy_all
    articles.destroy_all
    redirect_to sites_index_path, notice: t(".success", site_name: @site_name)
  end

  private

  def set_site_name_and_ensure_presence
    @site_name = params[:site_name]
    render_not_found unless Article.exists?(site_name: @site_name)
  end
end

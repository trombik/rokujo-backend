# Controller for ArticleCollection
class ArticleCollectionsController < ApplicationController
  before_action :set_article_collection, only: [:show, :edit, :update, :destroy]

  # GET /article_collections
  def index
    @article_collections = ArticleCollection.all
  end

  # GET /article_collections/1
  def show; end

  # GET /article_collections/new
  def new
    @article_collection = ArticleCollection.new
  end

  # GET /article_collections/1/edit
  def edit; end

  # POST /article_collections
  def create
    @article_collection = ArticleCollection.new(article_collection_params)

    respond_to do |format|
      if @article_collection.save
        format.html { redirect_to @article_collection, notice: t(".success") }
      else
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /article_collections/1
  def update
    respond_to do |format|
      if @article_collection.update(article_collection_params)
        format.html do
          redirect_to @article_collection, notice: t(".success"), status: :see_other
        end
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_content }
      end
    end
  end

  # DELETE /article_collections/1
  def destroy
    @article_collection.destroy!

    respond_to do |format|
      format.html do
        redirect_to article_collections_path, notice: t(".success"),
                                              status: :see_other
      end
    end
  end

  def articles
    article_collection = ArticleCollection.find(params[:id])
    @pagy, @articles = pagy(:countish,
                            article_collection.articles,
                            items: 20)
    render "articles/index"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article_collection
    @article_collection = ArticleCollection.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def article_collection_params
    params.expect(
      article_collection: [
        :name, :key, :value,
        { collection_tag_ids: [] }
      ]
    )
  end
end

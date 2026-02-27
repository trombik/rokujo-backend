# Controller for CollectionTag
class CollectionTagsController < ApplicationController
  before_action :set_collection_tag, only: [:show, :edit, :update, :destroy]

  layout "empty"

  # GET /collection_tags
  def index
    @collection_tags = CollectionTag.all
  end

  # GET /collection_tags/1
  def show; end

  # GET /collection_tags/new
  def new
    @collection_tag = CollectionTag.new
  end

  # GET /collection_tags/1/edit
  def edit; end

  # POST /collection_tags
  def create
    @collection_tag = CollectionTag.new(collection_tag_params)

    respond_to do |format|
      if @collection_tag.save
        format.html { redirect_to @collection_tag, notice: t(".success") }
      else
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /collection_tags/1
  def update
    respond_to do |format|
      if @collection_tag.update(collection_tag_params)
        format.html do
          redirect_to @collection_tag, notice: t(".success"), status: :see_other
        end
      else
        format.html { render :edit, status: :unprocessable_content }
      end
    end
  end

  # DELETE /collection_tags/1
  def destroy
    @collection_tag.destroy!

    respond_to do |format|
      format.html do
        redirect_to collection_tags_path, notice: t(".success"), status: :see_other
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_collection_tag
    @collection_tag = CollectionTag.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def collection_tag_params
    params.expect(collection_tag: [:name])
  end
end

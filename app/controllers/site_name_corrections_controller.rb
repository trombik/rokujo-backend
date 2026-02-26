# Controller for SiteNameCorrection
class SiteNameCorrectionsController < ApplicationController
  before_action :set_site_name_correction, only: [:show, :edit, :update, :destroy]
  layout "empty"

  # GET /site_name_corrections
  def index
    @site_name_corrections = SiteNameCorrection.all
  end

  # GET /site_name_corrections/1
  def show; end

  # GET /site_name_corrections/new
  def new
    @site_name_correction = SiteNameCorrection.new
  end

  # GET /site_name_corrections/1/edit
  def edit; end

  # POST /site_name_corrections
  def create
    @site_name_correction = SiteNameCorrection.new(site_name_correction_params)

    respond_to do |format|
      if @site_name_correction.save
        format.html { redirect_to @site_name_correction, notice: t(".success") }
      else
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /site_name_corrections/1
  def update
    respond_to do |format|
      if @site_name_correction.update(site_name_correction_params)
        format.html do
          redirect_to @site_name_correction, notice: t(".success"),
                                             status: :see_other
        end
      else
        format.html { render :edit, status: :unprocessable_content }
      end
    end
  end

  # DELETE /site_name_corrections/1
  def destroy
    @site_name_correction.destroy!

    respond_to do |format|
      format.html do
        redirect_to site_name_corrections_path, notice: t(".success"),
                                                status: :see_other
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_site_name_correction
    @site_name_correction = SiteNameCorrection.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def site_name_correction_params
    params.expect(site_name_correction: [:domain, :name])
  end
end

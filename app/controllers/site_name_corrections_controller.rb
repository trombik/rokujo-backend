# Controller for SiteNameCorrection
class SiteNameCorrectionsController < ApplicationController
  before_action :set_site_name_correction, only: [:show, :edit, :update, :destroy]
  before_action :set_on_success, only: [:new, :create, :update, :edit]

  # GET /site_name_corrections
  def index
    @site_name_corrections = SiteNameCorrection.all
  end

  # GET /site_name_corrections/1
  def show; end

  # GET /site_name_corrections/new
  def new
    @site_name_correction = SiteNameCorrection.find_or_initialize_by(domain: params[:domain]) do |correction|
      correction.name = params[:name]
    end
  end

  # GET /site_name_corrections/1/edit
  def edit; end

  # POST /site_name_corrections
  # rubocop:disable Metrics/MethodLength
  def create
    @site_name_correction = SiteNameCorrection.new(site_name_correction_params)
    respond_to do |format|
      if @site_name_correction.save
        format.html { redirect_to @site_name_correction, notice: t(".success"), status: :see_other }
        format.turbo_stream do
          redirect_to sites_show_path(@site_name_correction.name), status: :see_other if @on_success == "redirect"
        end
      else
        format.html { render :new, status: :unprocessable_content }
        format.turbo_stream { render :new, status: :unprocessable_content }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /site_name_corrections/1
  # rubocop:disable Metrics/MethodLength
  def update
    respond_to do |format|
      if @site_name_correction.update(site_name_correction_params)
        format.html { redirect_to @site_name_correction, notice: t(".success"), status: :see_other }
        format.turbo_stream do
          redirect_to sites_show_path(@site_name_correction.name), status: :see_other if @on_success == "redirect"
        end
      else
        format.html { render :edit, status: :unprocessable_content }
        format.turbo_stream { render :edit, status: :unprocessable_content }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

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

  def set_on_success
    @on_success = params[:on_success]
  end

  # Only allow a list of trusted parameters through.
  def site_name_correction_params
    params.expect(site_name_correction: [:domain, :name])
  end
end

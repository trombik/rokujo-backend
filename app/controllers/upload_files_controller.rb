# Receive files and pass them to jobs for importing artciles.
class UploadFilesController < ApplicationController
  before_action :disable_in_demo

  include NotificationHelper

  def new
    respond_to :turbo_stream
  end

  def create
    respond_to :turbo_stream
    files = params[:upload][:files].compact_blank
    if files.empty?
      flash.now[:alert] = t(".empty_files")
      return render :create, status: :unprocessable_content
    end

    saved_files(files).each { |f| ImportFileJob.perform_later(f) }
    broadcast_toast(title: "File upload", message: "Enqueued ImportFileJob.")
  end

  private

  def saved_files(files)
    files.map do |file|
      tmp_dir = Rails.root.join("storage/tmp_uploads")
      FileUtils.mkdir_p tmp_dir
      path = tmp_dir.join("#{SecureRandom.uuid_v7}-#{file.original_filename}")
      File.binwrite(path, file.read)
      path.to_s
    end
  end
end

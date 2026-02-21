# A controller to start or stop token analysis jobs
class TokenAnalysisManagersController < ApplicationController
  def status
    set_analysis_status
    render layout: false
  end

  def start
    EnqueueTokenAnalysisJob.perform_later
    set_analysis_status
    render "status", layout: false
  end

  def stop
    Rails.cache.write("stop_analysis_enqueue", true)
    SolidQueue::Job.where(class_name: %w[EnqueueTokenAnalysisJob AnalyzeTokensJob]).delete_all
    set_analysis_status
    render "status", layout: false
  end

  private

  def set_analysis_status
    @n_sentences = Sentence.all.size
    @n_sentences_without_tokens = Sentence.where.missing(:token_analyses).size
    @jobs_in_queue = SolidQueue::Job.where(class_name: "AnalyzeTokensJob").scheduled.size
  end
end

# A job to analyze a sentence
class AnalyzeTokensJob < ApplicationJob
  class TextAnalysisServiceNotAvailavleError < StandardError; end
  class SentenceNotFoundError < StandardError; end

  queue_as :analysis

  # retry because the analysis API server restarts after a certain number of
  # requests.
  retry_on TextAnalysisServiceNotAvailavleError

  # discard the job because SentenceNotFoundError should not happen and there
  # is no way to recover if the sentence does not exist.
  discard_on SentenceNotFoundError, report: true

  def perform(keys)
    article_uuid, line_number = keys
    sentence = Sentence.find_by(article_uuid: article_uuid, line_number: line_number)
    raise SentenceNotFoundError unless sentence

    analyze_and_store_pos(sentence)
  end

  def analysis_results(text)
    results = TextAnalysisService.call(text)
    raise TextAnalysisServiceNotAvailavleError unless results

    results
  end

  # rubocop:disable Metrics/AbcSize
  def analyze_and_store_pos(sentence)
    results = analysis_results(sentence.text)
    token_data = results.map do |t|
      {
        article_uuid: sentence.article_uuid,
        line_number: sentence.line_number,
        token_id: t["i"],
        text: t["text"],
        lemma: t["lemma"],
        pos: t["pos"],
        tag: t["tag"],
        head: t["head"],
        morph: t["morph"],
        start: t["idx"],
        end: t["idx"] + t["text"].size,
        dep: t["dep"]
      }
    end
    sentence.transaction do
      sentence.token_analyses.delete_all
      TokenAnalysis.import! token_data, validate: true
    end
  end
  # rubocop:enable Metrics/AbcSize
end

# A service to fetch tokens analysis from remote spacy API
class TextAnalysisService < ApplicationService
  attr_reader :text

  API_URL = "http://localhost:8000/analyze_tokens".freeze

  def initialize(text)
    @text = text
    super()
  end

  def call
    fetch(text)
  rescue StandardError => e
    Rails.logger.error "#{e.class}: #{e.message}"
    nil
  end

  private

  def uri
    @uri ||= URI(API_URL)
  end

  def request(text)
    request = Net::HTTP::Post.new(uri, { "Content-Type" => "application/json" })
    request.body = { text: text }.to_json
    request
  end

  def fetch(text)
    res = Net::HTTP.start(uri.hostname, uri.port, read_timeout: 60) do |http|
      http.request(request(text))
    end
    case res
    when Net::HTTPSuccess
      JSON.parse(res.body)["tokens"]
    else
      raise "Analysis API HTTP Error: #{res.code} #{res.message}"
    end
  end
end

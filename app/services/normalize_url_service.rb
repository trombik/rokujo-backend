# Provides URL normalization service.
class NormalizeUrlService < ApplicationService
  attr_reader :url

  # @param url [String] URL string.
  def initialize(url)
    @url = url
    super()
  end

  # Returns normalized URL string, `#{host}/#{path}`.
  #
  # @return [String]
  def call
    return "" if url.blank?

    uri = URI.parse(url.strip)
    path = uri.path == "/" ? "" : uri.path
    "#{uri.host}#{path}"
  rescue URI::InvalidURIError
    Rails.logger.error "Failed to parse URL: #{url} | Error: #{e.message}"
    ""
  end
end

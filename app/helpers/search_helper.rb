# Search-related helpers
module SearchHelper
  REGEXP_TAG = '(tag:\s*(?:"([^"]+)"|(\S+)))'.freeze
  REGEXP_SITE_NAME = '(site_name:\s*(?:"([^"]+)"|(\S+)))'.freeze
  REGEXP_URL = '(url:\s*(\S+))'.freeze

  # Extracts search operators from string
  def operators_from(word)
    word ||= ""
    {
      tags: word.scan(/#{REGEXP_TAG}/).map { |m| m[1] || m[2] },
      site_names: word.scan(/#{REGEXP_SITE_NAME}/).map { |m| m[1] || m[2] },
      urls: word.scan(/#{REGEXP_URL}/).pluck(1)
    }
  end

  def extract_word(word)
    return "" unless word

    word_without_operator = word.gsub(/#{REGEXP_TAG}/, "")
                                .gsub(/#{REGEXP_SITE_NAME}/, "")
                                .gsub(/#{REGEXP_URL}/, "") || ""
    splitted = word_without_operator.strip.split(/\s+/)
    return "" if splitted.empty?

    splitted.first
  end
end

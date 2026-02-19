# Search-related helpers
module SearchHelper
  # Extracts search operators from string
  def operators_from(word)
    word ||= ""
    {
      site_names: word.scan(/site_name:\s*(?:"([^"]+)"|(\S+))/).map { |m| m[0] || m[1] },
      urls: word.scan(/url:\s*(\S+)/).flatten
    }
  end
end

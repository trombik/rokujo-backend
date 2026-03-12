# frozen_string_literal: true

# Full text search form.
class SearchForm::FullTextComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  # @param keyword [String] The default search keyword in the text
  # field. The default is params[:word].
  def initialize(keyword: nil)
    @keyword = keyword
    super()
  end

  private

  def keyword
    @keyword || params[:word]
  end
end

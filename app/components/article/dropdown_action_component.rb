# frozen_string_literal: true

# A dropdown action button for an article
class Article::DropdownActionComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(article)
    @article = article
    super()
  end

  private

  attr_reader :article

  def uniq_key
    article.uuid
  end
end

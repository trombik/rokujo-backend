# frozen_string_literal: true

class SearchForm::FullTextComponentPreview < ViewComponent::Preview
  def default
    render(SearchForm::FullTextComponent.new)
  end
end

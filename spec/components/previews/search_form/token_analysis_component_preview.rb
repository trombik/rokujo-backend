# frozen_string_literal: true

class SearchForm::TokenAnalysisComponentPreview < ViewComponent::Preview
  def default
    render(SearchForm::TokenAnalysisComponent.new)
  end
end

# frozen_string_literal: true

class SearchForm::CollocationForVerbComponentPreview < ViewComponent::Preview
  def default
    render(SearchForm::CollocationForVerbComponent.new)
  end
end

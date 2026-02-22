# frozen_string_literal: true

class SearchForm::GroupComponentPreview < ViewComponent::Preview
  def default
    render(SearchForm::GroupComponent.new)
  end
end

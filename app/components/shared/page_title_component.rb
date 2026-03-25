# frozen_string_literal: true

# page title
class Shared::PageTitleComponent < ViewComponent::Base
  def initialize(title:, **options)
    @title = title
    @options = options
    super()
  end

  private

  attr_reader :title, :options
end

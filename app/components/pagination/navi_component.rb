# frozen_string_literal: true

# Navigation component for pagination
class Pagination::NaviComponent < ViewComponent::Base
  def initialize(page)
    @page = page
    super()
  end

  def render?
    page.present?
  end

  private

  attr_reader :page
end

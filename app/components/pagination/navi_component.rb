# frozen_string_literal: true

# Navigation component for pagination
class Pagination::NaviComponent < ViewComponent::Base
  attr_reader :page

  def initialize(page)
    @page = page
    super()
  end
end

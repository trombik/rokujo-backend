# frozen_string_literal: true

# A component to display information about the paged result
class Pagination::InfoComponent < ViewComponent::Base
  attr_reader :page

  def initialize(page)
    @page = page
    super()
  end

  def total_count
    page.data_hash(data_keys: [:count])[:count]
  end
end

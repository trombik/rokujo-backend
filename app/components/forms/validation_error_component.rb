# frozen_string_literal: true

# Common error message component for forms
class Forms::ValidationErrorComponent < ViewComponent::Base
  attr_reader :resource

  def initialize(resource)
    @resource = resource
    super()
  end
end

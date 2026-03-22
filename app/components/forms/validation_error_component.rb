# frozen_string_literal: true

# Common error message component for forms
class Forms::ValidationErrorComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(resource)
    @resource = resource
    super()
  end

  def render?
    resource.errors.any?
  end

  private

  attr_reader :resource
end

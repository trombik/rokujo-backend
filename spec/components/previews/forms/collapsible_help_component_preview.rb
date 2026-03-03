# frozen_string_literal: true

class Forms::CollapsibleHelpComponentPreview < ViewComponent::Preview
  # @!group
  def button
    render Forms::CollapsibleHelpComponent.new("demo").button_component
  end

  def help
    render Forms::CollapsibleHelpComponent.new("demo")
  end
  # @!endgroup
end

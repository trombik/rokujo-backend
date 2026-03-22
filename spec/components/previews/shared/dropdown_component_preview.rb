# frozen_string_literal: true

class Shared::DropdownComponentPreview < ViewComponent::Preview
  # rubocop:disable Metrics/MethodLength
  def default
    expanded = false

    render Shared::DropdownComponent.new(expanded: expanded) do |c|
      c.with_dropdown_button(text: "Actions", expanded: expanded)
      c.with_dropdown_item do
        "Action 1"
      end

      c.with_dropdown_item(disabled: true) do
        "Action 2 (disabled)"
      end

      c.with_dropdown_item(text: "Visit example.org", link: "http://example.org/")
    end
  end

  def expanded_menu
    expanded = true

    render Shared::DropdownComponent.new(expanded: expanded) do |c|
      c.with_dropdown_button(expanded: expanded) do
        "Actions"
      end

      c.with_dropdown_item do
        "Action 1"
      end

      c.with_dropdown_item(disabled: true) do
        "Action 2 (disabled)"
      end

      c.with_dropdown_item(link: "http://example.org/") do
        "Visit example.org"
      end
    end
  end

  def danger
    expanded = false

    render Shared::DropdownComponent.new(expanded: expanded) do |c|
      c.with_dropdown_button(expanded: expanded, classes: "btn-danger") do
        "Actions"
      end

      c.with_dropdown_item do
        "Action 1"
      end

      c.with_dropdown_item(disabled: true) do
        "Action 2 (disabled)"
      end

      c.with_dropdown_item do
        "Action 3"
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end

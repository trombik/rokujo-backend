# frozen_string_literal: true

# A basic dropdown menu
class Shared::DropdownComponent < ViewComponent::Base
  renders_one :dropdown_button, "DropdownButtonComponent"
  renders_many :dropdown_items, "DropdownItemComponent"

  include Concerns::IdentifiableComponent

  def initialize(expanded: false)
    @expanded = expanded
    super()
  end

  private

  attr_reader :expanded

  def classes
    "dropdown"
  end

  def data
    {
      testid: testid
    }
  end

  def show_class
    expanded ? "show" : ""
  end

  def dropdown_menu_classes
    "dropdown-menu #{show_class}".strip
  end

  # the button to open the menu
  class DropdownButtonComponent < ViewComponent::Base
    include Concerns::IdentifiableComponent

    def initialize(text: nil, expanded: false, classes: "", data: {}, aria: {})
      @text = text
      @classes = classes
      @expanded = expanded
      @data = data
      @aria = aria
      super()
    end

    def call
      tag.button class: classes,
                 type: "button",
                 data: data,
                 aria: aria do
                   content_or_text
                 end
    end

    private

    attr_reader :expanded, :text

    def content_or_text
      content || text
    end

    def data
      {
        bs_toggle: "dropdown",
        testid: testid
      }.deep_merge(@data)
    end

    def classes
      "btn btn-secondary dropdown-toggle #{@classes}".strip
    end

    def aria
      {
        expanded: expanded
      }.deep_merge(@aria)
    end
  end

  # the dropdown menu item
  class DropdownItemComponent < ViewComponent::Base
    include Concerns::IdentifiableComponent

    # rubocop:disable Metrics/ParameterLists
    def initialize(link: "#", text: nil, disabled: false, classes: nil, data: {}, aria: {})
      @link = link
      @text = text
      @classes = classes
      @disabled = disabled
      @data = data
      @aria = aria
      super()
    end
    # rubocop:enable Metrics/ParameterLists

    def call
      link_to link, class: classes,
                    data: data,
                    aria: aria do
        content_or_text
      end
    end

    private

    attr_reader :link, :disabled, :text

    def content_or_text
      content || text
    end

    def classes
      "dropdown-item #{disabled_class} #{@classes}".strip
    end

    def disabled_class
      disabled ? "disabled" : ""
    end

    def data
      {
        testid: testid
      }.deep_merge(@data)
    end

    def aria
      {
        disabled: disabled
      }.deep_merge(@aria)
    end
  end
end

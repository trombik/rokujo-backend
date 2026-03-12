# frozen_string_literal: true

# component to display a value and allow users to copy the value by clicking
# an icon. usefull to hide a long text in a tight space.
class Shared::CollapsedClipboardComponent < ViewComponent::Base
  def initialize(value:, label: nil, icon: "clipboard-plus", placement: :bottom)
    @value = value
    @label = label
    @icon = icon
    @placement = placement
    super()
  end

  attr_reader :value, :label, :icon, :placement

  def id
    return @id if @id

    random_hex = SecureRandom.hex(8)
    @id = "#{self.class.name.gsub("::", "_").underscore}_#{random_hex}"
  end

  def placement_classes
    case placement
    when :top
      "bottom-100 mb-2"
    when :bottom
      "mt-2"
    end
  end
end

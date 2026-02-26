# frozen_string_literal: true

# A thin wrapper for bootstarp icons
class IconComponent < ViewComponent::Base
  attr_reader :klass, :name

  def initialize(name, klass: "")
    @klass = klass
    @name = name
    super()
  end

  def icon_base_class
    "bi"
  end

  def icon_name_class
    "#{icon_base_class}-#{name}"
  end

  def prefix_class
    "#{icon_base_class} #{icon_name_class}"
  end
end

# frozen_string_literal: true

# Right off-canvas menu
class SideMenu::RightComponent < ViewComponent::Base
  attr_reader :klass

  def initialize(klass: {})
    @klass = klass
    super()
  end
  delegate :id, to: :class

  def self.id
    to_s.underscore.parameterize
  end
end

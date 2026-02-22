# frozen_string_literal: true

class SideMenu::RightComponentPreview < ViewComponent::Preview
  def default
    render SideMenu::RightComponent.new(klass: "show")
  end
end

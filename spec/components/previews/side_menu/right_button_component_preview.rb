# frozen_string_literal: true

class SideMenu::RightButtonComponentPreview < ViewComponent::Preview
  def default
    render(SideMenu::RightButtonComponent.new)
  end
end

require "rails_helper"

RSpec.describe "Notifications", :js, type: :system do
  include NotificationHelper

  describe "broadcast_toast" do
    it "sends a toast to global notifications frame" do
      visit root_path
      expect(page).to have_component(Notification::ToastFrameComponent)
      broadcast_toast(title: "Title", message: "Message", type: :info, delay: 1000)

      within find_component(Notification::ToastFrameComponent) do
        expect(page).to have_component(Notification::ToastComponent)
        within find_component(Notification::ToastComponent) do
          expect(page).to have_text "Title"
          expect(page).to have_text "Message"
        end
        expect(page).to have_no_component(Notification::ToastComponent)
      end
    end
  end
end

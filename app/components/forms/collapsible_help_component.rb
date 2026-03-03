# frozen_string_literal: true

# A component to display a help content and a button to open it.
#
# The help content is read from a markdown under app/docs/help.
class Forms::CollapsibleHelpComponent < ViewComponent::Base
  attr_reader :slug, :help_class, :btn_class

  def initialize(slug, help_class: nil, btn_class: nil)
    @help_class = help_class
    @btn_class = btn_class
    @slug = slug
    super()
  end

  def button_component
    ButtonComponent.new(id: id, klass: btn_class)
  end

  private

  def id
    "#{id_prefix}_#{slug}"
  end

  def id_prefix
    self.class.name.underscore.tr("/", "_")
  end

  def markdown_content
    md = help_file_path ? File.read(help_file_path) : "### Help content not found."
    md_content = Kramdown::Document.new(md, input: "GFM").to_html.gsub("<blockquote>", blockquote_tag)
    sanitize md_content
  end

  def blockquote_tag
    "<blockquote class='border-start border-3 border-info ps-3 my-3'>"
  end

  def help_file_path
    return @help_file_path if @help_file_path

    candidates = [
      Rails.root.join("app/docs/help/#{slug}.#{I18n.locale}.md"),
      Rails.root.join("app/docs/help/#{slug}.en.md")
    ]
    path = candidates.find { |f| File.exist?(f) }
    raise "help file not found in:\n#{candidates.map(&:to_s)}" if Rails.env.local? && path.blank?

    @help_file_path = path
  end

  # The button to open the help
  class ButtonComponent < ViewComponent::Base
    attr_reader :id, :klass

    def initialize(id:, klass:)
      @id = id
      @klass = klass
      super()
    end

    def call
      tag.button type: "button",
                 class: "btn p-0 border-0 link-primary line-height-1 ms-2 #{klass}",
                 title: "Help",
                 style: "font-size: 1.2rem;",
                 data: { bs_toggle: "collapse", bs_target: "##{id}" },
                 aria: { expanded: false, controls: id, label: "Help" } do
        tag.i class: "bi bi-question-circle"
      end
    end
  end
end

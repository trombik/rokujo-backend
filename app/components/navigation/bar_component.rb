# frozen_string_literal: true

# The Navbar
class Navigation::BarComponent < ViewComponent::Base
  def initialize(brand_name: "Bootstrap")
    @brand_name = brand_name
    super()
  end

  private

  def current_path_is_root?
    helpers.request.path == root_path
  end

  def navbar_content_id
    "navbarSupportedContent"
  end

  def links
    [
      { label: "Search", path: search_path },
      { label: "Articles", path: articles_path },
      { label: "Token analysis", path: token_analysis_analyzer_path },
      { label: "Article collections", path: article_collections_path },
      { label: "Corpus Dashboard", path: stats_index_path },
      { label: "Collection tags", path: collection_tags_path },
      { label: "Collect articles", path: collect_articles_path },
      { label: "Sites", path: sites_path }
    ]
  end

  # Link in the navbar
  class LinkComponent < ViewComponent::Base
    attr_reader :label, :path, :active, :disabled

    def initialize(label:, path:, active: false, disabled: false)
      @label = label
      @path = path
      @active = active
      @disabled = disabled
      super()
    end

    def active_class
      active ? "active" : ""
    end

    def disabled_class
      disabled ? "disabled" : ""
    end

    def aria
      {
        current: active ? "page" : "",
        disabled: disabled
      }
    end

    def call
      tag.li class: "nav-item" do
        link_to label,
                path,
                class: "nav-link #{active_class} #{disabled_class}",
                aria: aria
      end
    end
  end

  # Dropdown menu
  class DropDownComponent < ViewComponent::Base
    attr_reader :label

    renders_many :items, "DropDownItemComponent"

    def initialize(label:)
      @label = label
      super()
    end

    def call
      tag.li class: "nav-item dropdown" do
        concat(
          link_to(label, "#",
                  class: "nav-link dropdown-toggle",
                  role: "button",
                  data: { bs_toggle: "dropdown" },
                  aria: { expanded: false })
        )
        concat(
          tag.ul(class: "dropdown-menu") do
            items.each do |item|
              concat item
            end
          end
        )
      end
    end

    # Dropdown item
    class DropDownItemComponent < ViewComponent::Base
      attr_reader :label, :path

      def initialize(label:, path:)
        @label = label
        @path = path
        super()
      end

      def call
        tag.li do
          link_to label, path, class: "dropdown-item"
        end
      end
    end
  end

  # divider
  class DropDownDividerComponent < ViewComponent::Base
    def call
      tag.li do
        tag.hr class: "dropdown-divider"
      end
    end
  end

  # Menu toggler
  class TogglerComponent < ViewComponent::Base
    attr_reader :id

    def initialize(id:)
      @id = id
      super()
    end

    def call
      tag.button(class: "navbar-toggler",
                 type: "button",
                 data: {
                   bs_toggle: "collapse",
                   bs_target: "##{id}"
                 },
                 aria: {
                   controls: id,
                   expanded: false,
                   label: "Toggle navigation"
                 }) do
        tag.span class: "navbar-toggler-icon"
      end
    end
  end

  # Collapsable content
  class CollapsableContentComponent < ViewComponent::Base
    attr_reader :id

    def initialize(id:)
      @id = id
      super()
    end

    def call
      tag.div class: "collapse navbar-collapse", id: id do
        concat(content)
      end
    end
  end
end

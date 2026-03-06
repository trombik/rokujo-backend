# frozen_string_literal: true

# A form to enqueue CollectArticlesJob
class Forms::CollectArticlesComponent < ViewComponent::Base
  REGISTERED_SPIDERS = %w[read-more sitemap].freeze

  def initialize(spider_name = nil)
    @spider_name = spider_name if REGISTERED_SPIDERS.include? spider_name
    super()
  end

  def render?
    spider_name.present?
  end

  def self.for(spider_name)
    return unless REGISTERED_SPIDERS.include? spider_name

    subclass_name = spider_name.underscore.classify
    "#{name}::#{subclass_name}".constantize.new
  rescue NameError
    nil
  end

  def supported_args
    []
  end

  private

  attr_reader :spider_name

  def args
    supported_args.map do |key|
      help_component = Forms::CollapsibleHelpComponent.new("spider_#{key}")
      {
        name: key,
        help_component: help_component
      }
    end
  end

  # form for read-more spider
  class ReadMore < Forms::CollectArticlesComponent
    def initialize
      super("read-more")
    end

    def supported_args
      %w[urls read_more read_next read_next_contains source_contains source_parent_contains]
    end
  end

  # form for sitemap spider
  class Sitemap < Forms::CollectArticlesComponent
    def initialize
      super("sitemap")
    end

    def supported_args
      %w[urls sitemap_type]
    end
  end
end

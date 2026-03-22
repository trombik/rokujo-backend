# frozen_string_literal: true

# Sectionized grid component
class Layout::SectionGridComponent < ViewComponent::Base
  renders_one :header, "HeaderComponent"
  renders_many :cols, "ColumnComponent"

  def initialize(cols_per_row: 3, classes: "", **options)
    @cols_per_row = cols_per_row
    @classes = classes
    @options = options
    super()
  end

  private

  attr_reader :col, :options, :cols_per_row

  def row_component
    "#{self.class.name}::RowComponent".constantize.new
  end

  def n_rows
    cols.size / cols_per_row
  end

  def cols_next(slice)
    first = slice * cols_per_row
    last = first + cols_per_row - 1
    cols[first..last]
  end

  def col_witdh
    12 / cols_per_row
  end

  def classes
    "my-3 #{@classes}".strip
  end

  # The header
  class HeaderComponent < ViewComponent::Base
    def initialize(classes: "", **options)
      @classes = classes
      @options = options
      super()
    end

    def call
      concat(
        content_tag(:h2, class: classes, **options) do
          content
        end
      )
      concat(
        tag.hr(class: "flex-grow-1 ms-3 opacity-25")
      )
    end

    private

    attr_reader :options

    def classes
      "h5 fw-bold opacity-75 #{@classes}".strip
    end
  end

  # The row
  class RowComponent < ViewComponent::Base
    def initialize(classes: "", **options)
      @classes = classes
      @options = options
      super()
    end

    def call
      tag.div class: classes, **options do
        content
      end
    end

    private

    attr_reader :options

    def classes
      "row #{@classes}".strip
    end
  end

  # The colum
  class ColumnComponent < ViewComponent::Base
    attr_accessor :width

    def initialize(classes: "", **options)
      @classes = classes
      @options = options
      super()
    end

    def call
      tag.div(class: classes, **options) do
        content
      end
    end

    private

    attr_reader :options

    def classes
      "col col-md-#{@width} #{@classes}".strip
    end
  end
end

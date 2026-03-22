# frozen_string_literal: true

class Layout::SectionGridComponentPreview < ViewComponent::Preview
  def default
    render Layout::SectionGridComponent.new(cols_per_row: 4) do |c|
      c.with_header { "Header" }

      1.upto(10) do |i|
        c.with_col do
          "Col#{i}"
        end
      end
    end
  end
end

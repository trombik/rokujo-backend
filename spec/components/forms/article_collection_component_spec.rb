# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::ArticleCollectionComponent, type: :component do
  let(:article_collection) { build(:article_collection) }
  let(:component) { described_class.new(article_collection) }

  it "does not raise error" do
    expect { render_inline component }.not_to raise_error
  end
end

# frozen_string_literal: true

class Stats::SentencesPerArticleComponentPreview < ViewComponent::Preview
  def default
    render(Stats::SentencesPerArticleComponent.new(100))
  end

  def frame
    render(Stats::SentencesPerArticleComponent.new)
  end
end

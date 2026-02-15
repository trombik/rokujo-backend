# frozen_string_literal: true

require "ruby-spacy"

# Cache model and reuse it in all the examples
module SpacyHelper
  def model
    SpacyHelper.spacy_model
  end

  # keep model in class instance variable, avoiding global variable
  def self.spacy_model
    @spacy_model ||= Spacy::Language.new("ja_ginza")
  end
end

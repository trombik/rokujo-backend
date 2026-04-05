require "rails_helper"

RSpec.describe ImportTokenJob, type: :job do
  let(:article) { create(:article) }
  let(:token) do
    {
      "text" => "サンプル",
      "lemma" => "サンプル",
      "pos" => "NOUN",
      "tag" => "名詞-一般",
      "dep" => "root",
      "head" => 0,
      "start" => 0,
      "end" => 4,
      "i" => 1
    }
  end

  let!(:sentence) { create(:sentence, article: article, line_number: 1, text: token["text"], analyze: false) }

  it "creates a TokenAnalysis" do
    expect do
      described_class.perform_now(article_uuid: article.uuid,
                                  line_number: sentence.line_number,
                                  tokens: [token])
    end.to change(TokenAnalysis, :count).by(1)
  end
end

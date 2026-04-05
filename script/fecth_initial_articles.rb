require_relative "../config/environment"

# A script to generate db/initial_articles.jsonl. The script is called by
# db/seed.rb, i.e. `rails db:seed`.

# a service class to collect articles
class SpiderService
  def initialize(...); end

  def self.call(...)
    new(...).call
  end

  # Collect selected articles from Wikipedia.
  class WikipediaSelected < SpiderService
    TITLES = %w[
      明治維新
      第二次世界大戦
      産業革命
      原子力発電
      Ruby
      プログラミング言語
      インターネット
      キリスト教
      仏教
      イスラム教
      地球
      太陽系の形成と進化
      地球の未来
      K-Pg境界
      政府
      議会
      日本の裁判所
      資本論
      ケインズ経済学
      信用創造
      航空事故
      タイタニック号沈没事故
    ].freeze
    def call
      urls = TITLES.map { |title| "https://ja.wikipedia.org/wiki/#{title}" }
      file, status = CollectArticlesService.call("read-more", { urls: urls.join(",") })
      raise unless status.success?

      file.read.each_line.map { |line| JSON.parse(line) }
    end
  end

  # genpaku
  class Genpaku < SpiderService
    URL = "https://genpaku.org/1984/".freeze

    def call
      file, status = CollectArticlesService.call("directory", { url: URL })
      raise unless status.success?

      file.read.each_line.map { |line| JSON.parse(line) }
    end
  end

  # slib.net CC-BY articles
  class Slib < SpiderService
    URL = "https://slib.net/works/?type=&length=&copy=15&rating=&tag%5B%5D=on".freeze

    def call
      archive_next_xpath = "//div[@class='columns-guide']/a[contains(text(), '次へ')]/@href"
      archive_article_xpath = "//section[@class='component-work']//a[contains(text(), '読む')]/@href"
      file, status = ::CollectArticlesService.call("archive_spider",
                                                   { urls: URL,
                                                     archive_article_xpath: archive_article_xpath,
                                                     archive_next_xpath: archive_next_xpath })
      raise unless status.success?

      file.read.each_line.map { |line| JSON.parse(line) }
    end
  end

  # yamadas.org
  class Yamadas < SpiderService
    URL = "https://www.yamdas.org/column/technique/".freeze
    CC_LICENCE = "This work is licensed under a Creative Commons".freeze

    def call
      file, status = ::CollectArticlesService.call("directory", { url: URL })
      raise unless status.success?

      articles = file.read.each_line.map { |line| JSON.parse(line) }
      select_permissively_licensed_articles(articles)
    end

    def select_permissively_licensed_articles(articles)
      articles.select do |article|
        licence_lines = article["body"].each_line.select { |line| /#{CC_LICENCE}/.match(line) }
        licence_line = licence_lines.first
        next false unless licence_line
        next false if /\bNonCommercial/i.match(licence_line)
        next true if /\b(?:Attribution-Sharelike)\b\d+/i.match(licence_line)

        false
      end
    end
  end
end

SPIDERS = [
  SpiderService::WikipediaSelected,
  SpiderService::Genpaku,
  SpiderService::Yamadas,
  SpiderService::Slib
].freeze

articles = SPIDERS.map(&:call)

puts articles.flatten.compact_blank.map(&:to_json)

# A service to convert TEI document to HTML
class Tei2htmlService < ApplicationService
  def initialize(xml_string)
    @doc = Nokogiri::XML.fragment(xml_string)
    super()
  end

  def call
    replace_text_node_with_heading
    replace_tag("quote", "blockquote")
    replace_tag("item", "li")
    replace_tag("row", "tr")
    replace_tag("cell", "td")
    replace_list
    remove_lb
    doc.to_html
  end

  private

  attr_reader :doc

  def replace_tag(from, to)
    doc.search(from).each { |n| n.name = to }
  end

  def replace_list
    doc.search("list").each do |n|
      n.name = (n["rend"] == "ul" ? "ul" : "ol")
      n.remove_attribute("rend")
    end
  end

  def remove_lb
    doc.search("lb").each(&:remove)
  end

  def replace_text_node_with_heading
    doc.at_css("main")&.children&.each do |node|
      next unless node.text? && node.content.strip.present?

      heading = doc.document.create_element("h4", node.content.strip)
      node.replace(heading)
    end
  end
end

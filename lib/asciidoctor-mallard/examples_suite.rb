require 'asciidoctor/doctest/html/normalizer'

module Asciidoctor::Mallard
  ##
  # Module to be included into +Nokogiri::XML::Document+
  # or +DocumentFragment+ to add {#normalize!} feature.
  #
  # @example
  #   Nokogiri::XML.parse(str).normalize!
  #   Nokogiri::XML.fragment(str).normalize!
  class ExamplesSuite < Asciidoctor::DocTest::HTML::ExamplesSuite
    def convert_example(example, opts, renderer)
      header_footer = !!opts[:header_footer] || example.name.start_with?('document')

      xml = renderer.convert(example.content, header_footer: header_footer)
      xml = parse_xml(xml, !header_footer)

      # When asserting inline examples, ignore paragraph "wrapper".
      includes = opts[:include] || (@paragraph_xpath if example.name.start_with? 'inline_')

      Array.wrap(includes).each do |xpath|
        # XPath returns NodeSet, but we need DocumentFragment, so convert it again.
        xml = parse_xml(xml.xpath(xpath).to_xml)
      end

      Array.wrap(opts[:exclude]).each do |xpath|
        xml.xpath(xpath).remove
      end

      xml.normalize!

      create_example example.name, content: HtmlBeautifier.beautify(xml), opts: opts
    end

    private

    def parse_xml(str, fragment = true)
      fragment ? ::Nokogiri::XML.fragment(str) : ::Nokogiri::XML.parse(str)
    end
  end
end

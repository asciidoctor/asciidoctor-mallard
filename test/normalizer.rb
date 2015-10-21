require 'asciidoctor/doctest/html/normalizer'

module Asciidoctor::Mallard
  ##
  # Module to be included into +Nokogiri::XML::Document+
  # or +DocumentFragment+ to add {#normalize!} feature.
  #
  # @example
  #   Nokogiri::XML.parse(str).normalize!
  #   Nokogiri::XML.fragment(str).normalize!
  module Normalizer

    ##
    # Normalizes the XML document or fragment so it can be easily compared
    # with another XML.
    #
    # What does it actually do?
    #
    # * sorts element attributes by name
    # * sorts inline CSS declarations inside a +style+ attribute by name
    # * removes all blank text nodes (i.e. node that contain just whitespaces)
    # * strips nonsignificant leading and trailing whitespaces around text
    # * strips nonsignificant repeated whitespaces
    #
    # @return [Object] self
    #
    def normalize!
      traverse do |node|
        case node.type

        when Nokogiri::XML::Node::ELEMENT_NODE
          sort_element_attrs! node
          sort_element_style_attr! node

        when Nokogiri::XML::Node::TEXT_NODE
          # Remove text node that contains whitespaces only.
          if node.blank?
            node.remove

          elsif !preformatted_block? node
            strip_redundant_spaces! node
          end
        end
      end
      self
    end

    private

    # Sorts attributes of the element +node+ by name.
    def sort_element_attrs!(node)
      node.attributes.sort_by(&:first).each do |name, value|
        node.delete(name)
        node[name] = value
      end
    end

    # Sorts CSS declarations in style attribute of the element +node+ by name.
    def sort_element_style_attr!(node)
      return unless node.has_attribute? 'style'
      decls = node['style'].scan(/([\w-]+):\s*([^;]+);?/).sort_by(&:first)
      node['style'] = decls.map { |name, val| "#{name}: #{val};" }.join(' ')
    end

    # Note: muttable methods like +gsub!+ doesn't work on node content.

    # Strips repeated whitespaces in the text +node+.
    def strip_redundant_spaces!(node)
      node.content = node.content.gsub("\n", ' ').gsub(/(\s)+/, '\1')
    end

    # Sorts attributes of the element +node+ by name.  Exclude namespaced
    # attributes.
    def sort_element_attrs!(node)
      attrs = node.attribute_nodes.sort_by(&:name).reject(&:namespace)
      attrs.each do |attr|
        node.delete(attr.name)
        node[attr.name] = attr.content
      end
    end

    # Sorts style declarations.
    def sort_element_style_attr!(node)
      return unless node.has_attribute? 'style'
      node['style'] = node['style'].split(/\s+/).sort.join(' ')
    end

    # @return [Boolean] true if the +node+ is descendant of a +<code>+ or
    # +<screen>+ node.
    def preformatted_block?(node)
      node.path =~ %r{/(code|screen)/}
    end
  end
end

[Nokogiri::XML::Document, Nokogiri::XML::DocumentFragment].each do |klass|
  klass.send :include, Asciidoctor::Mallard::Normalizer
end

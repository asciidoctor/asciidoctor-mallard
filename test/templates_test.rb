require 'test_helper'
require 'asciidoctor-mallard/converter'
require 'asciidoctor-mallard/examples_suite'

class TestTemplates < DocTest::Test
  converter_opts backend_name: 'mallard',
    converter: Asciidoctor::Mallard::Converter
  generate_tests! Asciidoctor::Mallard::ExamplesSuite.new(file_ext: '.page')
end

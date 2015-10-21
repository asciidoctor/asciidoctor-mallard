require 'asciidoctor/doctest'
require 'asciidoctor-mallard/normalizer'
require 'minitest/autorun'

DocTest.examples_path.unshift 'test/examples/asciidoc' if File.exist? 'test/examples/asciidoc'
DocTest.examples_path.unshift 'test/examples/mallard'

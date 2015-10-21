require 'asciidoctor/doctest'
require_relative 'normalizer'
require 'minitest/autorun'

DocTest.examples_path.unshift 'test/examples/asciidoc' if File.exist? 'test/examples/asciidoc'
DocTest.examples_path.unshift 'test/examples/mallard'

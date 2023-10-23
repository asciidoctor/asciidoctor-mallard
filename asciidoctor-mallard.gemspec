# -*- encoding: utf-8 -*-
require File.expand_path('lib/asciidoctor-mallard/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = 'asciidoctor-mallard'
  s.version = Asciidoctor::Mallard::VERSION

  s.summary = 'Converts AsciiDoc documents to Project Mallard format'
  s.description = <<-EOS
An extension for Asciidoctor that converts AsciiDoc documents to Mallard 1.0.
  EOS

  s.authors = ['brian m. carlson']
  s.email = 'sandals@crustytoothpaste.net'
  s.homepage = 'https://github.com/asciidoctor/asciidoctor-mallard'
  s.license = 'MIT'

  s.required_ruby_version = '>= 1.9'

  begin
    s.files = `git ls-files -z -- */* {README.adoc,LICENSE.adoc,NOTICE.adoc,Rakefile}`.split "\0"
  rescue
    s.files = Dir['**/*']
  end

  s.executables = %w(asciidoctor-mallard)
  s.test_files = s.files.grep(/^(?:test|spec|feature)\/.*$/)
  s.require_paths = %w(lib)

  s.rdoc_options = %(--charset=UTF-8 --title="Asciidoctor Mallard" --main=README.adoc -ri)
  s.extra_rdoc_files = %w(README.adoc LICENSE.adoc)

  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'asciidoctor-doctest', '~> 1.5'
  s.add_development_dependency 'thread_safe', '~> 0.3.5'

  s.add_runtime_dependency 'asciidoctor', '~> 1.5.0'
end

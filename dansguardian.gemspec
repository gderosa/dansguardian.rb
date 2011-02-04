# -*- encoding: utf-8 -*-

$LOAD_PATH.unshift File.join File.dirname(__FILE__), 'lib'

require 'dansguardian'

Gem::Specification.new do |s|
  s.name = %q{dansguardian}
  s.version = DansGuardian::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Guido De Rosa"]
  s.date = Date.today.to_s
  s.description = %q{Manage DansGuardian configuration from Ruby -- http:/dansguardian.org/}
  s.email = %q{guido.derosa@vemarsas.it}
  s.files = [
    "Changelog",
    "README.rdoc",
    "example.rb",
    "lib/dansguardian.rb",
    "lib/dansguardian/config/constants.rb",
    "lib/dansguardian/config/filtergroup.rb",
    "lib/dansguardian/config/main.rb",
    "lib/dansguardian/extensions/float.rb",
    "lib/dansguardian/config.rb",
    "lib/dansguardian/inclusion.rb",
    "lib/dansguardian/parser.rb",
    "lib/dansguardian/updater.rb"
  ]
  s.homepage = %q{http://github.com/gderosa/dansguardian.rb}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.require_paths = ["lib"]
  s.summary = %q{Manage DansGuardian configuration from Ruby -- http:/dansguardian.org/}
  s.add_dependency 'configfiles'
end


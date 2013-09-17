lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "datatables_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "datatables_rails"
  spec.version       = DatatablesRails::VERSION
  spec.authors       = ["Michał Janeczek", "Mercomp"]
  spec.email         = ["michal.janeczek@ymail.com", "info@mercomp.pl"]
  spec.description   = "Helper for using DataTables in Rails."
  spec.summary       = "Helper for using DataTables in Rails."
  spec.homepage      = "http://github.com/mjaneczek/datatables-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_development_dependency 'guard-rspec'
end
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "common_views/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "common_views"
  s.version     = CommonViews::VERSION
  s.authors     = "Mercomp"
  s.email       = "info@mercomp.pl"
  s.homepage    = "https://github.com/mercomp/common_views"
  s.summary     = "Część wspólna wszystkich projektów rails"
  s.description = "Część wspólna wszystkich projektów rails"

  s.files = Dir["{app,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  #s.test_files = Dir["test/**/*"]

  #s.add_dependency "rails", "4.0.0"
end

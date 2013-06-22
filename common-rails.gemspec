$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "common-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "common-rails"
  s.version     = CommonRails::VERSION
  s.authors     = ["Mercomp", "Aleksander Podlaski"]
  s.email       = ["info@mercomp.pl"]
  s.homepage    = "https://github.com/mercomp/common-rails"
  s.summary     = "Część wspólna wszystkich projektów rails"
  s.description = "Część wspólna wszystkich projektów rails"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "railties", "4.0.0.rc2"

  s.add_development_dependency "sqlite3"
end

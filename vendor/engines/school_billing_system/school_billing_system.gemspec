$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "school_billing_system/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "school_billing_system"
  s.version     = SchoolBillingSystem::VERSION
  s.authors     = ["tabish.saleem"]
  s.email       = ["tabish.saleem@nxb.com.pk"]
  s.homepage    = "localhost:3000"
  s.summary     = "Summary of school billing system."
  s.description = "Description of school billing system."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.7.1"

  s.add_development_dependency "sqlite3"
  s.add_runtime_dependency "jquery-rails"
  s.add_runtime_dependency "jquery-ui-rails"
end

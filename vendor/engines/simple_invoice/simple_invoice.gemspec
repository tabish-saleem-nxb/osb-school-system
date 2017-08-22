$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple_invoice/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_invoice"
  s.version     = SimpleInvoice::VERSION
  s.authors     = ["tabish.saleem"]
  s.email       = ["tabish.saleem@nxb.com.pk"]
  s.homepage    = "localhost:3000"
  s.summary     = "Summary of SimpleInvoice."
  s.description = "Description of SimpleInvoice."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.15"

  s.add_development_dependency "sqlite3"
  # s.add_runtime_dependency "jquery-rails"
  # s.add_runtime_dependency "jquery-ui-rails"
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wordpress_tools/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Étienne Després", "Ju Liu"]
  gem.email         = ["etienne@molotov.ca", "ju.liu@welaika.com"]
  gem.description   = %q{Command line tool to manage WordPress installations.}
  gem.summary       = %q{Manage WordPress installations.}
  gem.homepage      = "http://github.com/welaika/wordpress_tools"
  gem.license       = "MIT"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "wordpress_tools"
  gem.require_paths = ["lib"]
  gem.version       = WordPressTools::VERSION

  gem.add_dependency "thor", ">= 0.18"

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "< 3"
  gem.add_development_dependency "fakeweb", "~> 1.3.0"
end

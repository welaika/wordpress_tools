# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wordpress_tools/version"

Gem::Specification.new do |spec|
  spec.name          = "wordpress_tools"
  spec.version       = WordPressTools::VERSION
  spec.authors       = ["Étienne Després", "Alessandro Fazzi", "Filippo Gangi Dino", "Ju Liu", "Fabrizio Monti"]
  spec.email         = ["etienne@molotov.ca", "alessandro.fazzi@welaika.com", "filippo.gangidino@welaika.com", "ju.liu@welaika.com", "fabrizio.monti@welaika.com"]
  spec.summary       = %q{Manage WordPress installations.}
  spec.description   = %q{Command line tool to manage WordPress installations.}
  spec.homepage      = "http://github.com/welaika/wordpress_tools"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1.2"

  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "activesupport", "~> 4.2"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "fakeweb", "~> 1.3"
  spec.add_development_dependency "pry-byebug", "~> 3.0"
  spec.add_development_dependency "priscilla", "~> 1.0"
end

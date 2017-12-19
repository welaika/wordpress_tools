lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wordpress_tools/version"

Gem::Specification.new do |spec|
  spec.name          = "wordpress_tools"
  spec.version       = WordPressTools::VERSION
  spec.authors       = ["Étienne Després",
                        "Alessandro Fazzi",
                        "Filippo Gangi Dino",
                        "Ju Liu",
                        "Fabrizio Monti",
                        "Matteo Piotto"]
  spec.email         = ["etienne@molotov.ca",
                        "alessandro.fazzi@welaika.com",
                        "filippo.gangidino@welaika.com",
                        "ju.liu@welaika.com",
                        "fabrizio.monti@welaika.com",
                        "matteo.piotto@welaika.com"]
  spec.summary       = "Manage WordPress installations."
  spec.description   = "Command line tool to manage WordPress installations."
  spec.homepage      = "http://github.com/welaika/wordpress_tools"
  spec.license       = "MIT"

  spec.files         =  `git ls-files -z`
                        .split("\x0")
                        .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4.1"

  spec.add_dependency "activesupport", "~> 5.0"
  spec.add_dependency "thor", "~> 0.19.1"

  spec.add_development_dependency "bundler", ">= 1.6.2"
  spec.add_development_dependency "priscilla", "~> 1.0"
  spec.add_development_dependency "pry-byebug", "~> 3.0"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "webmock"
end

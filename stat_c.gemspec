# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stat_c/version'

Gem::Specification.new do |spec|
  spec.name          = "stat_c"
  spec.version       = StatC::VERSION
  spec.authors       = ["Ryan Moore"]
  spec.email         = ["moorer@udel.edu"]
  spec.license       = "GPLv3"

  spec.summary       = %q{Fast, well documented C stats extension for Ruby.}
  spec.description   = %q{Fast, well documented C stats extension for Ruby.}
  spec.homepage      = "https://github.com/mooreryan/stat_c"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "ext"]

  spec.platform      = Gem::Platform::RUBY
  spec.extensions    = ["ext/stat_c/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler", "~> 0.9.7"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.6", ">= 4.6.4"
  spec.add_development_dependency "yard", "~> 0.8.7.6"
  spec.add_development_dependency "coveralls", "~> 0.8.11"
end

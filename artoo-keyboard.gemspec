# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "artoo-keyboard/version"

Gem::Specification.new do |s|
  s.name        = "artoo-keyboard"
  s.version     = Artoo::Keyboard::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Stewart"]
  s.email       = ["artoo@hybridgroup.com"]
  s.homepage    = "https://github.com/hybridgroup/artoo-keyboard"
  s.summary     = %q{Artoo adaptor for keyboard input}
  s.description = %q{Artoo adaptor for keyboard input}

  s.rubyforge_project = "artoo-keyboard"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'artoo', '>= 1.5.0'
end

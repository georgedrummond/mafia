# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "mafia"
  s.version     = Mafia::VERSION
  s.authors     = ["George Drummond"]
  s.email       = ["george@accountsapp.com"]
  s.homepage    = "git@github.com:georgedrummond/mafia.git"
  s.summary     = %q{Generator to create sinatra apps that are also gems}
  s.description = %q{Generator to create sinatra apps that are also gems}

  s.rubyforge_project = "mafia"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "thor"
end

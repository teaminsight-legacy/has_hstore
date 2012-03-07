# -*- encoding: utf-8 -*-
require File.expand_path('../lib/has_hstore/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Collin Redding"]
  gem.email         = ["collin.redding@reelfx.com"]
  gem.description   = %q{Postgres hstore support with AR 3.X}
  gem.summary       = %q{Postgres hstore support with AR 3.X}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "has_hstore"
  gem.require_paths = ["lib"]
  gem.version       = HasHstore::VERSION
  
  gem.add_dependency("activerecord",   [">=2.3"])
  
  gem.add_development_dependency("assert",        ["~>0.7"])
  gem.add_development_dependency("assert-mocha",  ["~>0.1"])
end

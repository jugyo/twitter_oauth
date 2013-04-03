# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "twitter_oauth/version"

Gem::Specification.new do |s|
  s.name        = "twitter_oauth"
  s.version     = TwitterOAuth::VERSION
  s.authors     = ["Richard Taylor"]
  s.email       = ["moomerman@gmail.com"]
  s.homepage    = "http://github.com/moomerman/twitter_oauth"
  s.summary     = %q{twitter_oauth is a Ruby client for the Twitter API using OAuth.}
  s.description = %q{twitter_oauth is a Ruby client for the Twitter API using OAuth.}

  s.rubyforge_project = "twitter_oauth"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<oauth>, [">= 0.4.1"])
  s.add_runtime_dependency(%q<json>, [">= 1.1.9"])
  s.add_runtime_dependency(%q<mime-types>, [">= 1.16"])
  s.add_development_dependency(%q<shoulda>, ["~> 2.0"])
  s.add_development_dependency(%q<mocha>)
  s.add_development_dependency(%q<rake>)

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end

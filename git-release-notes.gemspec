# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/release/notes/version'

Gem::Specification.new do |spec|
  spec.name          = "git-release-notes"
  spec.version       = GitReleaseNotes::VERSION
  spec.authors       = ["Jason Milkins"]
  spec.email         = ["jasonm23@gmail.com"]

  spec.summary       = %q{Gather release-notes from a git log.}
  spec.description   = "Find <% release-note %> entries in a git log and parse them out (from sha -> HEAD), includes metatag filtering."
  spec.homepage      = "https://github.com/opsmanager/git-release-notes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"

  spec.add_runtime_dependency 'thor', '~> 0.19'
end

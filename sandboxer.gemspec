
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sandboxer/version"

Gem::Specification.new do |spec|
  spec.name          = "sandboxer"
  spec.version       = Sandboxer::VERSION
  spec.authors       = ["Dmitry Smirnov"]
  spec.email         = ["dmitler@gmail.com"]

  spec.summary       = %q{Tool to configure and build Jenkins jobs with CLI.}
  spec.description   = %q{Easy way to manage Jenkins builds using CLI instead of web interface.}
  spec.homepage      = "https://github.com/dismir/sandboxer"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jenkins_api_client"
  spec.add_dependency "git"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"

  spec.add_development_dependency "pry"
end

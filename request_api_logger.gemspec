# frozen_string_literal: true

require_relative "lib/request_api_logger/version"

Gem::Specification.new do |spec|
  spec.name = "request_api_logger"
  spec.version = RequestApiLogger::VERSION
  spec.authors = ["THANG BUI QUANG"]
  spec.email = ["buiquangthangit@gmail.com"]

  spec.summary = "Log incomming request and send message to kafka."
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://google.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.3"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://google.com"
  spec.metadata["changelog_uri"] = "https://google.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'
  spec.add_dependency 'ruby-kafka', '>= 1.3.0'
  spec.add_dependency 'dry-configurable'
  spec.add_dependency 'actionpack', '>= 4.1.0'

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop",  "~> 1.21"
end

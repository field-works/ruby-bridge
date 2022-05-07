# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "field_reports"
  spec.version = "2.0.0"
  spec.authors = ["Field Works, LLC"]
  spec.email = ["support@field-works.co.jp"]
  spec.summary = "Field Reports Ruby Bridge"
  spec.description = "See users manual for details."
  spec.homepage = "https://field-works.co.jp/"
  spec.required_ruby_version = ">= 2.4.0"
  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0")
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
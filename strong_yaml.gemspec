Gem::Specification.new do |s|
  s.name = "strong_yaml"
  s.version = "1.0.2"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 3.1.0"
  s.summary = "Easy YAML type checking"
  s.description = "Allows for easy YAML parsing and type checking, as well as generators"
  s.authors = ["Philipp Schlesinger"]
  s.email = ["info@philcomm.dev"]
  s.homepage = "http://rubygems.org/gems/strong_yaml"
  s.license = "MIT"
  s.files = Dir.glob("{lib,bin}/**/*")
  # s.require_path = "lib"

  s.metadata = {
    "documentation_uri" => "https://github.com/OfficialPhilcomm/strong_yaml",
    "source_code_uri" => "https://github.com/OfficialPhilcomm/strong_yaml",
    "changelog_uri" => "https://github.com/OfficialPhilcomm/strong_yaml/blob/master/changelog.md"
  }
end

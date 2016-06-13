Gem::Specification.new do |s|
  s.name        = "valid-env"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Zach Dennis", "Sara Gibbons", "Sam Bleckley", "Mutually Human"]
  s.email       = ["zdennis@mutuallyhuman.com"]
  s.homepage    = "http://github.com/mhs/valid-env"
  s.summary     = "Ensures the environment contains the variables your code needs"
  s.description = "Valid-env allows you to specify the environment variables that are required, those that are optional, and those that depend on one another, and will throw a useful error message immediately if something is missing."

  s.required_rubygems_version = ">= 1.3.6"

  # We can probably soften this dependency a lot
  s.add_dependency "activemodel", "~> 4.2"

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
end

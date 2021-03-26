require_relative 'lib/undercover_checks/version'

Gem::Specification.new do |spec|
  spec.name          = 'undercover_checks'
  spec.version       = UndercoverChecks::VERSION
  spec.authors       = ['Jean-Francis Bastien']
  spec.email         = ['bhacaz@gmail.com']

  spec.summary       = 'Send Undercover report to a Pull Request Checks on Github'
  spec.description   = 'Send Undercover report to a Pull Request Checks on Github.'
  spec.homepage      = 'https://github.com/Bhacaz/undercover_checks'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/Bhacaz/undercover_checks'
    spec.metadata['changelog_uri'] = 'https://github.com/Bhacaz/undercover_checks'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'jwt', '~> 2'
end

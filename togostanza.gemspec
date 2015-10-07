lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'togostanza/version'

Gem::Specification.new do |spec|
  spec.name          = 'togostanza'
  spec.version       = TogoStanza::VERSION
  spec.authors       = ['Keita Urashima']
  spec.email         = ['ursm@esm.co.jp']
  spec.summary       = %q{Development tools of TogoStanza}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '~> 0'
  spec.add_runtime_dependency 'flavour_saver', '~> 0'
  spec.add_runtime_dependency 'haml', '~> 0'
  spec.add_runtime_dependency 'hashie', '~> 0'
  spec.add_runtime_dependency 'parallel', '~> 0'
  spec.add_runtime_dependency 'sinatra', '~> 0', '~> 0'
  spec.add_runtime_dependency 'sinatra-contrib', '~> 0'
  spec.add_runtime_dependency 'sparql-client', '~> 0'
  spec.add_runtime_dependency 'sprockets', '~> 0'
  spec.add_runtime_dependency 'thor', '~> 0'

  spec.add_development_dependency 'appraisal', '~> 0'
  spec.add_development_dependency 'bundler', '~> 0'
  spec.add_development_dependency 'capybara', '~> 0'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rspec', '~> 0'
  spec.add_development_dependency 'rspec-its', '~> 0'

  spec.required_ruby_version = '>= 1.9.3'
end

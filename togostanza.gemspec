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

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'flavour_saver'
  spec.add_runtime_dependency 'haml'
  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'parallel'
  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'sinatra-contrib'
  spec.add_runtime_dependency 'sparql-client'
  spec.add_runtime_dependency 'sprockets'
  spec.add_runtime_dependency 'thor'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'

  spec.required_ruby_version = '>= 1.9.3'
end

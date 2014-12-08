Gem::Specification.new do |s|
  s.name     = 'random_point_generator'
  s.version  = '0.0.1'
  s.date     = '2014-12-08'
  s.licenses =['MIT']
  s.summary  = 'Generates random map points, within an optional bounding box.'
  s.authors  = ['Kyle Tolle']
  s.email    = 'kyle@nullsix.com'
  s.files    = ['lib/random_point_generator.rb', 'spec/random_point_generator_spec.rb']
  s.homepage = 'https://github.com/kyletolle/random_point_generator'
  s.add_development_dependency 'rspec', '~> 3.0', '>= 3.0.0'
end


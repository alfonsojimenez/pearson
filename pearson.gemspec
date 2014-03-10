$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'pearson'
  s.version     = '1.1.0'
  s.authors     = ['Alfonso Jiménez']
  s.email       = ['yo@alfonsojimenez.com']
  s.homepage    = 'https://github.com/alfonsojimenez/pearson'
  s.summary     = %q{Pearson correlation coefficient calculator}
  s.description = %q{Pearson correlation coefficient calculator}

  s.files         = %w(Gemfile LICENSE.txt .ruby-version lib/pearson.rb)
  s.require_paths = ['lib']
  s.add_development_dependency('rspec', ['>= 2.14.0'])
end

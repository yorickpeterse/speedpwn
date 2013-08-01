require File.expand_path('../lib/speedpwn/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'speedpwn'
  gem.version     = SpeedPwn::VERSION
  gem.authors     = ['Yorick Peterse']
  gem.emails      = ['yorickpeterse@gmail.com']
  gem.summary     = 'Generates possible passwords for SpeedTouch/Thomson routers.'
  gem.description = gem.summary
  gem.executables = ['speedpwn']
  gem.license     = 'MIT'
  gem.has_rdoc    = 'yard'

  gem.required_ruby_version = '>= 1.9.3'

  gem.files = File.read(File.expand_path('../MANIFEST', __FILE__)).split("\n")

  gem.add_dependency 'slop'
  gem.add_dependency 'progress_bar'
end

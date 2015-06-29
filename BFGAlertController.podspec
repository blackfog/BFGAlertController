Pod::Spec.new do |s|
  # pod customization goes in here
  s.name     = 'BFGAlertController'
  s.version  = '0.1.0'
  s.platform = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.license  = { :type => 'MIT' }
  s.homepage = 'http://github.com/blackfog/BFGAlertController'
  s.summary  = 'Foo bar baz'
  s.requires_arc = true

  s.author = {
    'Craig Pearlman' => 'craig@blackfoginteractive.com'
  }
  s.source = {
    :git => 'https://github.com/blackfog/BFGAlertController.git',
    :tag => s.version
  }
  s.source_files = 'BFGAlertController/*.swift'
end

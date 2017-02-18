Pod::Spec.new do |s|
  s.name             = 'DAO'
  s.version          = '0.1.0'
  s.summary          = 'DAO pattern realization.'
  s.description      = 'DAO patter realization for Realm and CoreData'
  s.homepage         = 'https://github.com/n-borzenko/DAO'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Natalia Borzenko' => 'n-borzenko93@yandex.ru' }
  s.source           = { :git => 'https://github.com/n-borzenko/DAO.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.source_files = 'DAO/**/*'
  s.frameworks = 'CoreData', 'Foundation'
  s.dependency 'RealmSwift', '~> 2.4'
end

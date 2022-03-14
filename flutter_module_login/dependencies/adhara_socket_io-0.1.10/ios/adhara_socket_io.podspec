#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'adhara_socket_io'
  s.version          = '0.0.1'
  s.summary          = 'socket.io for flutter by adhara'
  s.description      = <<-DESC
socket.io for flutter by adhara
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Socket.IO-Client-Swift', "13.3.1"
  s.dependency 'Starscream', '<= 3.0.5'

  s.ios.deployment_target = '8.0'
end


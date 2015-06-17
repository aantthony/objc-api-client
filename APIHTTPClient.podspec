Pod::Spec.new do |s|

  s.name         = "APIHTTPClient"
  s.version      = "1.0.2"
  s.summary      = "Simple HTTP client"

  s.description  = <<-DESC
                   Easy to use HTTP client with support for REST APIs, JSON serialization and deserialization.
                   DESC

  s.homepage     = "https://github.com/aantthony/objc-api-client"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = 'Anthony Foster'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.source       = { :git => "https://github.com/aantthony/objc-api-client.git", :tag => "v1.0.2"}

  s.source_files = "APIClient/*.{h,m}"
  s.exclude_files = "APIClientTests/*.{h,m}"

  s.public_header_files = "APIClient/*.h"
  s.header_dir = "APIClient"

  s.weak_frameworks = "Foundation"
  s.requires_arc = true

end

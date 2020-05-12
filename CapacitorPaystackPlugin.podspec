
  Pod::Spec.new do |s|
    s.name = 'CapacitorPaystackPlugin'
    s.version = '0.0.1'
    s.summary = 'Paystack capacitor plugin for Android and iOS'
    s.license = 'MIT'
    s.homepage = 'https://github.com/bot101/capacitor-paystack'
    s.author = 'Okafor Ikenna'
    s.source = { :git => 'https://github.com/bot101/capacitor-paystack', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
  end
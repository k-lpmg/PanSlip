Pod::Spec.new do |s|
  s.name         = "PanSlip"
  s.version      = "1.3.0"
  s.summary      = "Use PanGesture to dismiss view on UIViewController and UIView."
  s.homepage     = "https://github.com/k-lpmg/PanSlip"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "DongHee Kang" => "kanglpmg@gmail.com" }
  s.source       = { :git => "https://github.com/k-lpmg/PanSlip.git", :tag => s.version.to_s }
  s.documentation_url = "https://github.com/k-lpmg/PanSlip/blob/master/README.md"

  s.ios.source_files  = "Sources/**/*.swift"
  s.ios.deployment_target = "8.0"
end

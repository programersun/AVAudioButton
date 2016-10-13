
Pod::Spec.new do |s|

s.name                 = "AVAudioButton"
s.version              = "1.0.0"
s.summary              = "AVAudioButton"
s.homepage             = "https://github.com/programersun/AVAudioButton"
s.license              = { :type => "MIT", :file => "LICENSE" }
s.author               = { "Rui Sun" => "18513600046@163.com" }
s.platform             = :ios, "8.0"
s.source               = { :git => "https://github.com/programersun/AVAudioButton.git", :tag => s.version }
s.source_files         = "AVAudioButton/*.{h,m}"
s.resources            = "AVAudioButton/images/*.png"
s.frameworks           = "AVFoundation","AudioToolbox","UIKit"
s.requires_arc         = true

end

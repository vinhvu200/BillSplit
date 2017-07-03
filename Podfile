platform :ios, '9.0'

target 'BillSplit' do
  use_frameworks!
  pod 'TesseractOCRiOS', '4.0.0'
  # Pods for BillSplit

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
	        config.build_settings['ENABLE_BITCODE'] = 'NO'
		end
	end
end

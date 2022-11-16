#
# Be sure to run `pod lib lint TokenView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TokenView'
  s.version          = '0.5.0'
  s.summary          = 'View which can hold tokens and select them from a picker.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  View container based on UICollectionView used to display tokens. It also allows adding new ones through 
  UITextField entry and possibility to attach a picker selection view.
                       DESC

  s.swift_version    = "5.0"
  s.homepage         = 'https://github.com/jrpinteno/TokenView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xavi R. Pinteño' => 'xavi@jrpinteno.me' }
  s.source           = { :git => 'https://github.com/jrpinteno/TokenView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/**/*'

end

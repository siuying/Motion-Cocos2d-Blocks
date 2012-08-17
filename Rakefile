# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'bundler'
Bundler.require :default

Motion::Project::App.setup do |app|
  app.name = 'blocks'
  app.files_dependencies "app/app_delegate.rb" => ["app/commons/cocos2d_app_delegate.rb", "app/commons/touch_sprite.rb"]

  app.pods do 
    pod do |s|
      s.name = 'cocos2d'
      s.license = 'MIT'
      s.version = '2.1.0.pre'
      s.summary = 'cocos2d for iPhone is a framework for building 2D games, demos, and other graphical/interactive applications for iPod Touch, iPhone, iPad and Mac. It is based on the cocos2d design but instead of using python it, uses objective-c.'
      s.homepage = 'http://www.cocos2d-iphone.org'
      s.author = {
        'Ricardo Quesada' => 'ricardoquesada@gmail.com',
        'Zynga Inc.' => 'https://zynga.com/'
      }
      s.source = {:git => 'https://github.com/cocos2d/cocos2d-iphone.git', :commit => '04d1ad21487de8624243f7905d113c6715537d21'}
      s.source_files = ['cocos2d/**/*.{h,m,c}', 'external/kazmath/src/**/*.{c,h}', 'external/kazmath/include/**/*.{c,h}'] +
        FileList['external/libpng/*.{h,c}'].exclude(/pngtest/)
      s.xcconfig = {
        'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/cocos2d/external/kazmath/include"'
      }
      s.frameworks = ["OpenGLES", "QuartzCore", "GameKit"]
      s.library = 'z'
      s.prefix_header_contents = '''
#define CC_ENABLE_GL_STATE_CACHE 1
'''
      s.subspec 'CocosDenshion' do |p|
        p.source_files = 'CocosDenshion/CocosDenshion/*.{h,m}'
        p.frameworks = ["OpenAL", "AVFoundation", "AudioToolbox"]
      end

      def s.copy_header_mapping(from)
        from.relative_path_from(Pathname.new('cocos2d'))
      end
    end
  end
end

## automate image preparation

require 'fileutils'
task :prepare do
  # rename @2x files to -hd file
  FileList["resources_src/block/*@2x.png"].each do |filename|
    new_filename = filename.gsub(/@2x.png$/, '-hd.png')
    FileUtils.cp(filename, new_filename)
  end

  # copy files to resources
  FileList["resources_src/block/*.png"].each do |filename|
    unless filename =~ /@2x.png$/
      FileUtils.cp(filename, "resources/#{File.basename(filename)}")
    end
  end
end
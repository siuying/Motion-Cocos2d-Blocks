class AppDelegate < Cocos2dAppDelegate
  attr_reader :scene
  attr_reader :sound_engine

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    super

    @sound_engine = SimpleAudioEngine.sharedEngine
    @sound_engine.preloadEffect 'complete.wav'
    @sound_engine.preloadEffect 'blip.wav'
    @sound_engine.preloadEffect 'reset.wav'

    @scene = Stage.node
    director.pushScene @scene

    true
  end
end
class AppDelegate < Cocos2dAppDelegate
  attr_reader :scene

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    super

    @scene = Stage.node
    director.pushScene @scene

    true
  end
end
class AppDelegate < Cocos2dAppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    super

    @scene = CCScene.node
    @scene.addChild Stage.node
    @scene

    director.pushScene @scene

    true
  end
end
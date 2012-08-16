class Block < TouchSprite
  BLOCK_TOUCH_BEGIN     = "block.touch.begin"
  BLOCK_TOUCH_CANCELLED = "block.touch.cancelled"
  BLOCK_TOUCH_ENDED     = "block.touch.ended"
  
  attr_accessor :bk_color         # block color, can be one of [:red, :green, yello, blue]

  def self.with_color(color)
    block = Block.spriteWithFile "block-#{color.to_s}.png"
    block.bk_color = color.to_s
    block
  end

  # when touch begin, change to highlighted color
  def group_touch_begin
    self.opacity = 150
  end

  # when touch cancelled, revert color
  def group_touch_cancelled
    self.opacity = 255
  end

  # when touch ended, remove this block
  def group_touch_ended
    self.opacity = 255
  end

  ## CCNode Life Cycle

  def onEnter
    super

    nc = App.notification_center
    @observers = []

    @observers << nc.observe(BLOCK_TOUCH_BEGIN) do |notification|      
    end

    @observers << nc.observe(BLOCK_TOUCH_CANCELLED) do |notification|
    end

    @observers << nc.observe(BLOCK_TOUCH_ENDED) do |notification|
    end
  end

  def onExit
    super
    @observers.each do |o|
      App.notification_center.unobserve(o)
    end
  end

  ## Override TouchSprite
  # When touch occurs, send events to all blocks with same colors

  def touchesBegan(touches, withEvent:event)
    group_touch_begin
    App.notification_center.post BLOCK_TOUCH_BEGIN, bk_color
  end

  def touchesCancelled(touches, withEvent:event)
    group_touch_cancelled
    App.notification_center.post BLOCK_TOUCH_CANCELLED, bk_color
  end

  def touchesEnded(touches, withEvent:event)
    group_touch_ended
    App.notification_center.post BLOCK_TOUCH_ENDED, bk_color
  end
end
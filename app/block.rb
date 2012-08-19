class Block < TouchSprite
  COLORS = [:red, :green, :blue, :yellow]
  BLOCK_TOUCH_BEGIN     = "block.touch.begin"
  BLOCK_TOUCH_CANCELLED = "block.touch.cancelled"
  BLOCK_TOUCH_ENDED     = "block.touch.ended"
  
  attr_accessor :bk_color         # block color, can be one of [:red, :green, yello, blue]
  attr_accessor :x, :y

  def self.with_color(color)
    block = Block.spriteWithFile "block-#{color.to_s}.png"
    block.bk_color = color.to_s
    block
  end

  def self.with_random_color
    color = rand(COLORS.length)
    Block.with_color(COLORS[color])
  end

  # when touch begin, change to highlighted color
  def group_touch_begin
    self.opacity = 150
  end

  # when touch cancelled, revert color
  def group_touch_cancelled
    self.opacity = 255
  end

  # when touch ended, revert color
  def group_touch_ended
    self.opacity = 255
  end

  def to_s
    "<Block #{x},#{y} #{bk_color}>"
  end

  ## Override TouchSprite

  def touchesBegan(touches, withEvent:event)
    App.notification_center.post BLOCK_TOUCH_BEGIN, self
  end

  def touchesCancelled(touches, withEvent:event)
    App.notification_center.post BLOCK_TOUCH_CANCELLED, self
  end

  def touchesEnded(touches, withEvent:event)
    App.notification_center.post BLOCK_TOUCH_ENDED, self
  end
end
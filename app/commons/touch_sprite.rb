# A sprite that handle touch event
class TouchSprite < CCSprite
  attr_reader :touching

  def onEnter
    super
    CCTouchDispatcher.sharedDispatcher.addStandardDelegate(self, priority:0)
  end

  def onExit
    super
    CCTouchDispatcher.sharedDispatcher.removeDelegate(self)
  end

  def touchesBegin(touches, withEvent:event)
  end

  def touchesCancelled(touches, withEvent:event)
  end

  def touchesEnded(touches, withEvent:event)
  end

  ## CCStandardTouchDelegate

  def ccTouchesBegan(touches, withEvent:event)
    if touches_content(touches)
      touchesBegan(touches, withEvent:event)
      @touching = true
    end
  end

  def ccTouchesCancelled(touches, withEvent:event)
    if @touching
      touchesCancelled(touches, withEvent:event)
      @touching = false
    end
  end

  def ccTouchesEnded(touches, withEvent:event)
    if @touching
      if touches_content(touches)
        touchesEnded(touches, withEvent:event)
        @touching = false
      else
        ccTouchesCancelled(touches, withEvent:event)
      end
    end
  end

  private
  # check if content of this node contains the touches
  def touches_content(touches)
    director            = CCDirector.sharedDirector
    touch               = touches.anyObject
    touchLocation       = touch.locationInView(director.openGLView)
    locationGL          = director.convertToGL(touchLocation)
    locationInNodeSpace = self.convertToNodeSpace(locationGL)
    bbox                = [[0, 0], [self.contentSize.width, self.contentSize.height]]
    return CGRectContainsPoint(bbox, locationInNodeSpace)
  end
end
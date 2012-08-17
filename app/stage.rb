class Stage < CCLayer
  PAGE_MARGIN = 14.0

  attr_reader :score_label, :score
  attr_reader :rows

  ## CCNode Life Cycle

  def init
    super
    self.scheduleUpdate
    self
  end

  def onEnter
    super

    setup_ui
    setup_scene    
    setup_observers
  end

  def onExit
    super

    teardown_observers
  end

  ## Public 

  # update scene
  def update(dt)
    # remove blocks that is marked to be "remove"
    @removed.each do |block|
      @rows[block.x].delete(block)
      self.removeChild(block, cleanup:true)
    end

    # for empty hole, drop the blocks above them down
    @skipped = []
    @rows.each_with_index do |row, x_index|
      @skipped << x_index if row.size == 0

      row.each_with_index do |block, y_index|
        block.x = x_index - @skipped.size
        block.y = y_index
        block.position = position_with_coordinate(block.x, block.y, block.contentSize.width)
      end
    end
    @rows = @rows.select {|r| r.size > 0 }
    @removed = []
  end

  # reset the scene
  def reset(sender)
    App.delegate.sound_engine.playEffect("reset.wav")
    @blocks.each do |block|
      self.removeChild(block, cleanup:true)
    end
    setup_scene
  end

  # get block at coordinate
  #
  # @params x y coordinate
  # @params y x coordinate
  #
  # @return blocks with specific coordinate
  def block_at(x, y)
    if x >= 0 && y >= 0 && x < @rows.length && y < @rows[x].size
      @rows[x][y]
    else
      nil
    end
  end

  # Find group of blocks at position
  #
  # @params x y coordinate
  # @params y x coordinate
  #
  # @return array of blocks which is connected and with same color
  def group_at(x, y)
    block   = block_at(x, y)
    return [] unless block
    
    group       = [block]
    adj_blocks  = adjacent_blocks(block)
      .select {|bk| bk.bk_color == block.bk_color }

    while !adj_blocks.empty? do
      next_adj_blocks = []

      adj_blocks.each do |adj_block|
        group           << adj_block
        next_adj_blocks << adjacent_blocks(adj_block)
          .reject {|bk| group.include?(bk) }
          .select {|bk| bk.bk_color == block.bk_color }
      end

      adj_blocks = next_adj_blocks.flatten.uniq
    end

    group
  end

  private
  def setup_ui
    @score_label              = CCLabelTTF.labelWithString("Score: 0", fontName:"AppleGothic", fontSize:20, dimensions:[200, 24], hAlignment:KCCTextAlignmentLeft)
    @score_label.position     = [0, 0]
    @score_label.anchorPoint  = [0, 0]
    self.addChild @score_label

    @reset_button     = CCMenuItemImage.itemFromNormalImage("Reset.png", selectedImage:"ResetSelected.png", target:self, selector:'reset:')
    @reset_button.anchorPoint = [1, 0]

    @menu             = CCMenu.menuWithArray [@reset_button]
    @menu.position    = [320, 0]
    @menu.anchorPoint = [1, 0]
    self.addChild @menu
  end

  def setup_scene
    @removed = []
    @blocks = []
    @rows = []
    @score = 0

    18.times do |y|
      15.times do |x|
        block = build_colored_block(x, y)
        self.addChild block, z:1

        @rows[x] ||= []
        @rows[x] << block
        @blocks << block
      end
    end

    refresh_score
  end

  def setup_observers
    @observers = []
    @observers << App.notification_center.observe(Block::BLOCK_TOUCH_BEGIN) do |notification|
      block = notification.object
      group = group_at(block.x, block.y)
      group.each do |block|
        block.group_touch_begin
      end
    end
    
    @observers << App.notification_center.observe(Block::BLOCK_TOUCH_CANCELLED) do |notification|
      block = notification.object
      group = group_at(block.x, block.y)
      group.each do |block|
        block.group_touch_cancelled
      end
    end
    
    @observers << App.notification_center.observe(Block::BLOCK_TOUCH_ENDED) do |notification|
      block = notification.object
      group = group_at(block.x, block.y)
      group_size = group.size
      group.each do |block|
        block.group_touch_ended
        @removed << block if group_size > 1
      end

      # score by group
      if group_size > 1
        @score += (group_size - 2)**2
        refresh_score
        App.delegate.sound_engine.playEffect("complete.wav")
      else
        App.delegate.sound_engine.playEffect("blip.wav")
      end
    end
  end

  def teardown_observers
    @observers.each do |ob|
      App.notification_center.unobserve ob
    end
  end

  def position_with_coordinate(x, y, block_width)
    [
      PAGE_MARGIN + x * (block_width + 3.0), 
      76 + PAGE_MARGIN + y * (block_width + 3.0)
    ]
  end

  def build_colored_block(x, y)
    block = Block.with_random_color
    block.x = x
    block.y = y
    block.position = position_with_coordinate(x, y, block.contentSize.width)
    block
  end

  def adjacent_blocks(block)
    return [] unless block

    [[-1, 0], [1, 0], [0, -1], [0, 1]].collect do |offset|
      block_at(block.x + offset[0], block.y + offset[1])
    end.compact
  end

  def refresh_score
    @score_label.string = "Score: #{@score}"
  end

end
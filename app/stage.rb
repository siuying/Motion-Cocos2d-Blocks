class Stage < CCLayer 
  COLORS = [:red, :green, :blue, :yellow]
  PAGE_MARGIN = 14.0

  ## CCNode Life Cycle

  def onEnter
    super

    @blocks = []
    18.times do |y|
      15.times do |x|
        block = build_colored_block(x, y)
        self.addChild block, z:1
        @blocks << block
      end
    end
  end

  def onExit
    super
  end

  private
  def build_colored_block(x, y)
    color = rand(COLORS.length)
    block = Block.with_color(COLORS[color])
    block.position = [
      PAGE_MARGIN + x * (block.contentSize.width + 3.0), 
      76 + PAGE_MARGIN + y * (block.contentSize.height + 3.0)
    ]
    block
  end
end
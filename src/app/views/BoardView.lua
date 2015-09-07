local BoardView = class('BoardView', cc.load("mvc").ViewBase)

local board_w = 500
local board_h = 500

function BoardView:onCreate()
   self.board = ccui.Scale9Sprite:create(utils.img 'board-background', cc.rect(0,0,100,100), cc.rect(15,15,70,70))
      :setContentSize(cc.size(board_w, board_h))
      :move(display.center)
      -- :addTo(self)
   cc.Sprite:create(utils.img 'board-background')
      :addTo(self)
      :move(display.center)
   print('boardVirew')
end

return BoardView

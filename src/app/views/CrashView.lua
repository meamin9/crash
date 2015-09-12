local CrashView = class('CrashView', cc.load('mvc').ViewBase)
local TileSprite = import '.TileSprite'
local TileModel = import '..crash.TileModel'
local CrashModel = import '..crash.CrashModel'

local BORDER = 14
local aside = TileModel.getAside() + 10

function CrashView:onCreate()
   self.model = CrashModel.new()
   cc.LayerColor:create(cc.c4b(0, 128, 128, 128)):addTo(self)
   self.board = ccui.Scale9Sprite:create(utils.img 'board-background', cc.rect(15,15,70,70), cc.rect(0,0,70,70))
      :setContentSize(cc.size(self.model:getCol()*aside, self.model:getRow()*aside))
      :move(display.center)
      :addTo(self)
   self:draw_board_grids()
   self:create_tile_view()
   self:installTouchLayer()
end

function CrashView:installTouchLayer()
   cc.Layer:create():addTo(self)
      :onTouch(handler(self, self.onTouchEvent))
   self.selected_tile_ = nil
end

function CrashView:onTouchEvent(event)
   print(event.name)
   if event.name == 'began' then
      return self:onTouchBegan(event)
   elseif event.name == 'move' then
      return self:onTouchMove(event)
   elseif event.name == 'ended' then
      --
   else
   end
end

function CrashView:onTouchBegan(event)
   local p = self.board:convertToNodeSpace(cc.p(event.x, event.y))
   local col = math.floor(p.x/aside)+1
   local row = math.floor(p.y/aside)+1
   local tile = self.model:getTile(row, col)
   print('touch ', row, col, tile, self.selected_tile_)
   print(p.x,p.y, event.x, event.y)

   if not tile then
      if self.selected_tile_ then
         self.selected_tile_:onSelectedCancel()
         self.selecred_tile_ = nil
      end
      return false
   end
   if not self.selected_tile_ then
      self.selected_tile_ = tile
      tile:onSelected()
      return true
   end
   if tile:can_exchange_with_tile(self.selected_tile_) == false then
      self.selected_tile_:onSelectedCancel()
      tile:onSelected()
      self.selected_tile_ = tile
      return true
   end
   self.selected_tile_:onSelectedCancel()
   local tile_a = self.selected_tile_
   self.selected_tile_ = nil
   print('ex',tile:getColIdx(),tile_a:getColIdx())
   self.model:exchangeTwoTiles(tile_a, tile)
   return false
end

function CrashView:onTouchMove(event)
   if not self.selected_tile_ then
      return
   end
   local p = self.board:convertToNodeSpace(cc.p(event.x, event.y))
   local col = math.floor(p.x/aside)+1
   local row = math.floor(p.y/aside)+1
   local tile = self.model:getTile(row, col)
   if not tile then
      return
   end
   --you hua
   if tile:can_exchange_with_tile(self.selected_tile_) == false then
      return
   end
   local tile_a = self.selected_tile_
   self.selected_tile_ = nil
   tile_a:onSelectedCancel()
   self.model:exchangeTwoTiles(tile_a, tile)
end

function CrashView:getTileView(point)
   local p = self.board:convertToNodeSpace(point)
   return math.floor(p.x/aside), math.floor(p.y/aside)
end

function CrashView:create_tile_view()
   local row = self.model:getRow()
   local col = self.model:getCol()
   for i = 1, row do
      for j = 1, col do
         local tile = self.model:getTile(i, j)
         local sprite = TileSprite.new(tile)
         sprite:setPosition(aside/2 + (j-1)*aside, aside/2 + (i-1)*aside)
         self.board:addChild(sprite)
      end
   end
end

function CrashView:draw_board_grids()
   local glNode = gl.glNodeCreate()
   glNode:setContentSize(self.board:getContentSize())
   glNode:setAnchorPoint(cc.p(0.5, 0.5))
   local function primitivesDraw(transform, transformUpdated)
      kmGLPushMatrix()
      kmGLLoadMatrix(transform)

      local border = BORDER  * display.contentScaleFactor
      local size = self.board:getContentSize()
      local lbottom = cc.p(0,0)
      local ltop = cc.p(0, size.height)
      local rbottom = cc.p(size.width, 0)
      local rtop = cc.p(size.width, size.height)
      local border_lbottom = cc.p(-border, -border)
      local border_ltop = cc.p(-border, size.height + border)
      local border_rbottom = cc.p(size.width + border, -border)
      local border_rtop = cc.p(size.width + border, size.height + border)
      gl.lineWidth(1)
      cc.DrawPrimitives.drawColor4B(128, 0, 256, 128)
      local points = {border_lbottom, border_ltop, ltop, lbottom}
      cc.DrawPrimitives.drawSolidPoly(points, 4, cc.c4f(0.5, 0, 1, 0.5))
      points = {lbottom, rbottom, border_rbottom, border_lbottom}
      cc.DrawPrimitives.drawSolidPoly(points, 4, cc.c4f(0.5, 0, 1, 0.5))
      points = {rbottom, rtop, border_rtop, border_rbottom}
      cc.DrawPrimitives.drawSolidPoly(points, 4, cc.c4f(0.5, 0, 1, 0.5))
      points = {ltop, rtop, border_rtop, border_ltop}
      cc.DrawPrimitives.drawSolidPoly(points, 4, cc.c4f(0.5, 0, 1, 0.5))

      cc.DrawPrimitives.drawColor4B(64, 64, 64, 128)
      for i = 0, self.model:getRow() do
         cc.DrawPrimitives.drawLine(cc.p(0, i*aside), cc.p(size.width, i*aside))
         cc.DrawPrimitives.drawLine(cc.p(i*aside, 0), cc.p(i*aside, size.height))
      end

      kmGLPopMatrix()
   end
   glNode:registerScriptDrawHandler(primitivesDraw)
   local size = self.board:getContentSize()
   glNode:setPosition(size.width/2, size.height/2)
   self.board:addChild(glNode)
end

return CrashView

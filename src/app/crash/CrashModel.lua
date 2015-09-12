local CrashModel = class('CrashModel')
local TileModel = import('.TileModel')
local TileFactory = import '.TileFactory'
local CrashConfig = import '.CrashConfig'
local operator = import '.CrashOperator'

utils.define_class_property(CrashModel, 'col', 8)
utils.define_class_property(CrashModel, 'row', 8)

function CrashModel:ctor()
   assert(not crash.tmp.crash_model, 'crash_model is a single instance')
   crash.tmp.crash_model = self
   self.config = CrashConfig.new()
   self.tileFactory = TileFactory.new()
   self.tile_matrix = self.tileFactory:create_tile_matrix()
   self.hit_tiles_ = {}
   self:collectHitTiles()
   --assert has hit tile
end

function CrashModel:getTile(row_idx, col_idx)
   return (self.tile_matrix[row_idx] or {})[col_idx]
end

function CrashModel:getConfig()
   return self.config
end

function CrashModel:exchangeTwoTiles(tile1, tile2)
   tile1:addMovingRestrict()
   tile2:addMovingRestrict()
   local view1 = tile1:getView()
   local view2 = tile2:getView()
   local p1 = {}
   local p2 = {}
   p1.x, p1.y = view1:getPosition()
   p2.x, p2.y = view2:getPosition()
   local move2p2 = cc.MoveTo:create(0.2, p2)
   local move2p1 = cc.MoveTo:create(0.2, p1)
   local delay = cc.DelayTime:create(0.1)
   if self.hit_tiles_[tile1] and self.hit_tiles[tile1][tile2] or
   self.hit_tiles_[tile2] and self.hit_tiles[tile2][tile1] then
      print('crash exchange')
      local callback1 = cc.CallFunc:create(
         function()
            self:crashTile(tile1)
         end
      )
      local callback2 = cc.CallFunc:create(
         function()
            self:crashTile(tile2)
         end
      )
      view1:runAction(cc.Sequence:create(move2p2, delay, callback1))
      view2:runAction(cc.Sequence:create(move2p1, delay, callback2))
   else
      local callback1 = cc.CallFunc:create(
         function()
            tile1:removeMovingRestrict()
         end
      )
      local callback2 = cc.CallFunc:create(
         function()
            tile2:removeMovingRestrict()
         end
      )
      view1:runAction(cc.Sequence:create(move2p2, delay, move2p1, callback1))
      view2:runAction(cc.Sequence:create(move2p1, delay, move2p2, callback2))
   end
end

function CrashModel:crashTile(tile)

   --end
end

function CrashModel:checkCrashPossibility(i, j, tile)
   local tile_type = tile:getType()
   if self.tile_matrix[i][j-2] and self.tile_matrix[i][j-2]:getType() == tile_type and
   self.tile_matrix[i][j-2]:getType() == tile_type then
      return true
   elseif self.tile_matrix[i][j+2] and self.tile_matrix[i][j+2]:getType() == tile_type and
   self.tile_matrix[i][j+1]:getType() == tile_type then
      return true
   elseif self.tile_matrix[i+2] and self.tile_matrix[i+2][j]:getType() == tile_type and
   self.tile_matrix[i+1][j]:getType() == tile_type then
      return true
   elseif self.tile_matrix[i-2] and self.tile_matrix[i-2][j]:getType() == tile_type and
   self.tile_matrix[i-1][j]:getType() == tile_type then
      return true
   end
   return false
end

function CrashModel:collectHitTiles()
   for i = 1, self.row do
      for j = 1, self.col do
         local tile = self.tile_matrix[i][j]
         local tile_type = tile:getType()
         for dir in pairs({1, -1}) do
            local iftile = self.tile_matrix[i+dir] and self.tile_matrix[i+dir][j]
            if iftile and iftile:getType() ~= tile_type and self:checkCrashPossibility(i+dir, j, tile) then
               tile[iftile] = true
            elseif iftile then
               tile[iftile] = nil
            end
         end
         for dir in pairs({1, -1}) do
            local iftile = self.tile_matrix[i][j+dir]
            if iftile and iftile:getType() ~= tile_type and self:checkCrashPossibility(i, j+dir, tile) then
               tile[iftile] = true
            elseif iftile then
               tile[iftile] = nil
            end
         end
      end
   end
end

return CrashModel

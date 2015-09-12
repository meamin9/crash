local TileModel = class('TileModel')

function TileModel:ctor(tile_type, row_idx, col_idx)
   self.type = tile_type -- tile_type can be nil
   self.rowIdx = row_idx
   self.colIdx = col_idx
   self.hits = {}
   self.restrict_ = {}
end

utils.define_property(TileModel, 'rowIdx')
utils.define_property(TileModel, 'colIdx')
utils.define_property(TileModel, 'type')
utils.define_property(TileModel, 'view')
utils.define_class_property(TileModel, 'aside', 50)

function TileModel:cleanup()
   self.view = nil
   self.type = nil
end

function TileModel:setHit(direct, value)
   self.hits[direct] = value
   --direct in {'right', 'up', 'left', 'bottom'}
end

function TileModel:hasHit(direct)
   return self.hits[direct] == true
end

function TileModel:getImg()
   return crash.tmp.crash_model:getConfig():getImg(self.type)
end

function TileModel:onSelected()
end

function TileModel:onSelectedCancel()
end

function TileModel:addMovingRestrict()
   self.restrict_['moving'] = true
end

function TileModel:removeMovingRestrict()
   self.restrict_['moving'] = nil
end

function TileModel:hasMovingRestrict()
   return self.restrict_['moving']
end

function TileModel:canExchange()
   return not self:hasMovingRestrict()
end

function TileModel:canCrashWithTile(tile)
   return self:getType() == tile:getType()
end

--operator
function TileModel:can_exchange_with_tile(tile_b)
   if not self:canExchange() or not tile_b:canExchange() then
      return false
   end
   local row_offset = math.abs(self.rowIdx - tile_b:getRowIdx())
   local col_offset = math.abs(self.colIdx - tile_b:getColIdx())
   return row_offset + col_offset == 1
end

return TileModel

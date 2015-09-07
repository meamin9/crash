local TileModel = class('TileModel')

function TileModel:ctor(tile_type, row_idx, col_idx)
   self.type = tile_type -- tile_type can be nil
   self.rowIdx = row_idx
   self.colIdx = col_idx
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

function TileModel:getImg()
   return crash.tmp.crash_model:getConfig():getImg(self.type)
end

return TileModel

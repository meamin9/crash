local CrashModel = class('CrashModel')
local TileModel = import('.TileModel')
local TileFactory = import '.TileFactory'
local CrashConfig = import '.CrashConfig'

function CrashModel:ctor()
   assert(not crash.tmp.crash_model, 'crash_model is a single instance')
   crash.tmp.crash_model = self
   self.config = CrashConfig.new()
   self.tileFactory = TileFactory.new()
   self.tile_matrix = self.tileFactory:create_tile_matrix()
end

utils.define_class_property(CrashModel, 'col', 8)
utils.define_class_property(CrashModel, 'row', 8)

function CrashModel:getTile(row_idx, col_idx)
   return self.tile_matrix[row_idx][col_idx]
end

function CrashModel:getConfig()
   return self.config
end

return CrashModel

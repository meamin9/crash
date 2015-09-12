local DebugPanel = class('DebugPanel', cc.Node)
local wight = 300
local height = 400
local inputHeight = 32
function DebugPanel:ctor()
   self.table_items_ = {}
   self.bg = cc.LayerColor:create(cc.c4b(128, 128, 0, 128))
      :addTo(self)
      :setContentSize(cc.size(wight, height))
   self.tableView_ = cc.TableView:create(cc.size(width, height-inputHeight))
      :addTo(self)
   self.tableView_:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
   self.tableView_:setPosition(0, inputHeight)
   self.tableView_:registerScriptHandler(self.cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
   self.tableView_:registerScriptHandler(self.tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
   self.tableView_:registerScriptHandler(self.numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
   self.tableView_:reloadData()
   self.editBox = cc.EditBox:create(cc.size(width, inputHeight), '')
      :addTo(self)
--   self.editBox_:setPosition(0, 0)
   self.editBox_:registerScriptEditBoxHandler(self.editBoxTextEventHandler)

end

function DebugPanel.cellSizeForTable(table, idx)
   local self = table:getParent()
   return width, self.table_items_[idx].height
end

function DebugPanel.tableCellAtIndex(table, idx)
   local self = table:getParent()
   local cell = table:dequeueCell()
   if not cell then
      cell = cc.TableViewCell:create()
      local item = self.table_items_[idx]
      local text = string.format('>%s\n%s', item.cmd, item.cmd_result)
      local label = cc.Label:createWithSystemFont(item.text, 'Arial')
      label:setWidth(width)
      cell:addChild(label, 9)
      item.height = lable:getBoundingBox().height
   else
      local label = cell:getChildByTag(9)
      label:setString(self.table_items_[idx].text)
   end
   return cell
end

function DebugPanel.numberOfCellsInTableView(table)
   local self = table:getParent()
   return #self.table_items_
end

function DebugPanel.editBoxTextEventHandler(eventName, edit)
   local self = edit:getParent()
   if eventName == 'return' then
      local text = string.strim(edit:getText())
      edit:setText('')
      if text == '' then
         return
      end
      self:execCommond(text)
   end
end

function DebugPanel:execCommond(str)
   local item = {}
   item.cmd = str
   local f = loadstring('return ('..str..')')
   if not f then
      f = loadstring(str)
   end
   if not f then
      item.cmd_result = 'syntax error'
   else
      item.cmd_result = ''..f()
   end
   self.tableView_:reloadData()
end

utils = utils or {}
utils.DebugPanel = DebugPanel
return DebugPanel

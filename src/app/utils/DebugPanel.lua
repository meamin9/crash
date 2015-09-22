local DebugPanel = class('DebugPanel', cc.Node)
local width = 600
local height = 400
local inputHeight = 32
local table_items = {}
local MAX_COUNT = 100
local RECORD_COUNT = 20
local selectedItemIndex = 1
function DebugPanel:ctor()
   self.bg = cc.LayerColor:create(cc.c4b(90, 10, 90, 235))
      :addTo(self)
      :setContentSize(cc.size(width, height))
   self.tableView_ = cc.TableView:create(cc.size(width, height-inputHeight))
      :addTo(self)
   self.tableView_:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
   self.tableView_:setPosition(0, inputHeight)
   self.tableView_:setAnchorPoint(cc.p(0,0))
   self.tableView_:setDelegate()
   self.tableView_:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
   self.tableView_:registerScriptHandler(self.cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
   self.tableView_:registerScriptHandler(self.tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
   self.tableView_:registerScriptHandler(self.numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
   self.tableView_:reloadData()
   self.editBox_ = ccui.EditBox:create(cc.size(width, inputHeight), 'notfondimg.png')--'transparent.png')
      :addTo(self,100)
   self.editBox_:setAnchorPoint(cc.p(0, 0))
   self.editBox_:setPosition(0, 0)
   self.editBox_:registerScriptEditBoxHandler(self.editBoxTextEventHandler)
end

function DebugPanel.cellSizeForTable(table, idx)
   return width, table_items[idx+1].height
end

function DebugPanel.tableCellAtIndex(table, idx)
   idx = idx + 1
   local cell = table:dequeueCell()
   local item = table_items[idx]
   local text = DebugPanel.getItemText(item)
   if not cell then
      cell = cc.TableViewCell:new()
      local label = cc.Label:createWithSystemFont(text, 'Arial', 20)
      label:setColor(cc.c3b(238,238,238))
      label:setWidth(width)
      label:setTag(9)
      label:setAnchorPoint(display.LEFT_BOTTOM)
      label:setPosition(0,0)
      cell:addChild(label)
   else
      local label = cell:getChildByTag(9)
      label:setString(text)
   end
   return cell
end

function DebugPanel.numberOfCellsInTableView(table)
   return #table_items
end

function DebugPanel.editBoxTextEventHandler(eventName, edit)
   if eventName == 'changed' then
      local text = edit:getText()
      local flag = string.sub(text, -2, -1)
      if flag == 'PP' then
         selectedItemIndex = selectedItemIndex - 1
         if selectedItemIndex <= 0 then
            selectedItemIndex = #table_items + 1
            text = ''
         else
            text = table_items[selectedItemIndex].cmd
         end
         edit:setText(text)
      elseif flag == 'NN' then
         selectedItemIndex = selectedItemIndex + 1
         if selectedItemIndex > #table_items then
            selectedItemIndex = #table_items +1
            text = ''
         else
            text = table_items[selectedItemIndex].cmd
         end
         edit:setText(text)
      end
   elseif eventName == 'return' then
      local text = string.trim(edit:getText())
      edit:setText('')
      if text == '' then
         return
      end
      edit:getParent():execCommond(text)
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
      local statu, msg = xpcall(f, __G__TRACKBACK__)
      item.cmd_result = msg
   end
   DebugPanel.addItem(item)
   self.tableView_:reloadData()
   if self.tableView_:getContentOffset().y < 0 then
      self.tableView_:setContentOffset(cc.p(0, 0))
   end
end

function DebugPanel.addItem(item)
   item.height = DebugPanel.getItemHeight(item)
   table.insert(table_items, item)
   if #table_items > MAX_COUNT then
      for i = 1, RECORD_COUNT do
         table_items[i] = table_items[MAX_COUNT - RECORD_COUNT + i + 1]
      end
   end
   selectedItemIndex = #table_items + 1
end

function DebugPanel.getItemHeight(item)
   local label = cc.Label:createWithSystemFont(DebugPanel.getItemText(item), 'Arial', 20)
   label:setWidth(width)
   return label:getBoundingBox().height
end

function DebugPanel.getItemText(item)
   return string.format('> %s\n%s', item.cmd, item.cmd_result)
end

utils = utils or {}
utils.DebugPanel = DebugPanel
function utils.showDebugPanelSwitcher(scene)
   scene = scene or cc.Director:getInstance():getRunningScene()
   --local clippingNode = cc.ClippingNode:create()
   --clippingNode:setContentSize(cc.size(100, 100))
   local drawNode = cc.DrawNode:create()
   drawNode:setContentSize(cc.size(100, 100))
   drawNode:drawSolidCircle(cc.p(50, 50), 40, math.pi*2, 60, 1, 1, cc.c4f(0,0,0,255))
   drawNode:setPosition(100,100)
   scene:addChild(drawNode)
   local listener = cc.EventListenerTouchOneByOne:create()
   listener:registerScriptHandler(function()print('touch began')end, cc.Handler.EVENT_TOUCH_BEGAN)
   local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
   eventDispatcher:addEventListenerWithSceneGraphPriority(listener, drawNode)
end

return DebugPanel

local utils = utils or {}

function utils.img(path)
   local s = path..'.jpg'
   if cc.FileUtils:getInstance():isFileExist(s) then
      return s
   end
   s = path..'.png'
   if cc.FileUtils:getInstance():isFileExist(s) then
      return s
   end
   print('WARING: maybe not find image "'..path..'"')
   return path
end

function utils.define_property(class_name, property_name, default)
   local method_name = string.capitalize(property_name)
   class_name['get'..method_name] = function(self)return self[property_name] end
   class_name['set'..method_name] = function(self, value) self[property_name] = value end
   if default ~= nil then
      class_name[property_name] = default
   end
end

function utils.define_class_property(class_name, property_name, default)
   local method_name = string.capitalize(property_name)
   class_name['get'..method_name] = function()return class_name[property_name] end
   class_name['set'..method_name] = function(value) class_name[property_name] = value end
   if default ~= nil then
      class_name[property_name] = default
   end
end

function utils.touchEventInNodeContent(touch, event)
  local target = event:getCurrentTarget()
  local pos = target:convertToNodeSpace(touch:getLocation())
  local size = target:getContentSize()
  if 0 <= pos.x and pos.x <= size.width and
  0 <= pos.y and pos.y <= size.height then
     return true
  end
  return false
end

function utils.registerNodeScriptClickHanlder(handler, node)
   local listener = cc.EventListenerTouchOneByOne:create()
   local function onTouchBegan(touch, event)
      local target = event:getCurrentTarget()
      local pos = target:convertToNodeSpace(touch:getLocation())
      local size = target:getContentSize()
      if 0 < pos.x and pos.x < size.width and
      0 < pos.y and pos.y < size.height then
         return true
      end
      return false
   end
   local function onTouchEnded(touch, event)
      local target = event:getCurrentTarget()
      local pos = target:convertToNodeSpace(touch:getLocation())
      local size = target:getContentSize()
      if 0 < pos.x and pos.x < size.width and
      0 < pos.y and pos.y < size.height then
         handler()
      end
   end
   listener:registerScriptHandler(onTouchBegan, cc.Hanler.EVENT_TOUCH_BEGAN)
   listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
   local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
   eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end

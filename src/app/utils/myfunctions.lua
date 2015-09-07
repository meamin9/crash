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
   class_name['get'..method_name] = function(self)return self[property_name] or default end
   class_name['set'..method_name] = function(self, value) self[property_name] = value end
end

function utils.define_class_property(class_name, property_name, default)
   local method_name = string.capitalize(property_name)
   class_name['get'..method_name] = function()return class_name[property_name] or default end
   class_name['set'..method_name] = function(value) class_name[property_name] = value end
end

WinsLabel = {}
WinsLabel.__index = WinsLabel

function WinsLabel.create()
  local self = setmetatable({}, WinsLabel)
  self.obj = nil
  self.bid = "0"
  return self
end

function WinsLabel:draw(data, playerColor)
  self:hide()
  local label = spawnObject(
    {
      type = "3DText",
      position = data.labelPosition,
      rotation = data.labelRotation
    }
  )
  
  label.setLock(true)
  self.obj = label
  self:update(0)
end

function WinsLabel:init(bid)
  self.bid = tostring(bid)
  self:update(0)
end

function WinsLabel:update(wins)
  self.obj.TextTool.setValue(tostring(wins) .. "/" .. self.bid)
  self.obj.TextTool.setFontColor(wins == tonumber(self.bid) and Color.White or Color.Red)
end

function WinsLabel:hide()
  if (self.obj ~= nil) then
    self.obj.destruct()
  end
end
WinsLabel = {}
WinsLabel.__index = WinsLabel

function WinsLabel.create()
  local self = setmetatable({}, WinsLabel)
  self.obj = nil
  self.bid = "0"
  return self
end

function WinsLabel:draw(data, playerColor)
  if (self.obj ~= nil) then
    self.obj.destruct()
  end
  local label = spawnObject(
    {
      type = "3DText",
      position = data.labelPosition,
      rotation = data.labelRotation
    }
  )
  
  label.setLock(true)
  label.TextTool.setFontColor(playerColor)
  label.TextTool.setValue("0")
  self.obj = label
end

function WinsLabel:init(bid)
  self.bid = tostring(bid)
  self:update(0)
end

function WinsLabel:update(wins)
  self.obj.TextTool.setValue(tostring(wins) .. "/" .. self.bid)
end
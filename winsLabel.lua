
function winsLabelDraw(playerColor)
  local data = staticData.players[playerColor]
  local label = spawnObject(
    {
      type = "3DText",
      position = data.labelPosition,
      rotation = data.labelRotation
    }
  )
  
  savedData.labels[playerColor] = label
  label.setLock(true)
  label.TextTool.setFontColor(playerColor)
  label.TextTool.setValue("0")
end

function winsLabelUpdate(playerColor)
  local label = savedData.labels[playerColor]
  label.TextTool.setValue(tostring(savedData.rounds[savedData.round][playerColor].wins))
end
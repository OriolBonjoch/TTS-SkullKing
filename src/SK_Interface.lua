require("src.ui.scaryMaryPrompt")
require("src.ui.scoreBoard")

SK_Interface = {}
SK_Interface.__index = SK_Interface

function SK_Interface.create()
  local self = setmetatable({}, SK_Interface)
  self.ScoreBoard = ScoreBoardUI.create()
  self.ScaryMaryPrompt = ScaryMaryPromptUI.create()
  local assets = {}
  self.ScaryMaryPrompt:fillAssets(assets)
  UI.setCustomAssets(assets)
  return self
end

function SK_Interface:draw()
  local items = {}
  local scoreBoard = self.ScoreBoard:getXml()
  local scaryMaryPrompt = self.ScaryMaryPrompt:getXml()
  if scoreBoard then table.insert(items, scoreBoard) end
  if scaryMaryPrompt then table.insert(items, scaryMaryPrompt) end
  UI.setXmlTable({{ tag="Panel", children=items }})
end
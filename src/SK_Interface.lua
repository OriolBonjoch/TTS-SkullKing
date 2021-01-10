require("src.ui.scaryMaryPrompt")
require("src.ui.scoreBoard")
require("src.ui.start")

SK_Interface = {}
SK_Interface.__index = SK_Interface

function SK_Interface.create()
  local self = setmetatable({}, SK_Interface)
  self.ScoreBoard = ScoreBoardUI.create()
  self.ScaryMaryPrompt = ScaryMaryPromptUI.create()
  self.Start = StartUI.create()
  local assets = {}
  self.ScaryMaryPrompt:fillAssets(assets)
  UI.setCustomAssets(assets)
  return self
end

function SK_Interface:draw()
  local items = {}
  local scoreBoard = self.ScoreBoard:getXml()
  local scaryMaryPrompt = self.ScaryMaryPrompt:getXml()
  local startPrompt = self.Start:getXml()
  if scoreBoard then table.insert(items, scoreBoard) end
  if scaryMaryPrompt then table.insert(items, scaryMaryPrompt) end
  if startPrompt then table.insert(items, startPrompt) end
  UI.setXmlTable({{ tag="Panel", children=items }})
end

function SK_Interface:hasGame()
  if (not self.ScoreBoard) then return false end
  return self.ScoreBoard.show ~= "final" and self.ScoreBoard.show ~= ""
end
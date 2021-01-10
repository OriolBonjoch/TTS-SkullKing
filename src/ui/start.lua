StartUI = {}
StartUI.__index = StartUI

function StartUI.create()
  local self = setmetatable({}, StartUI)
  self.isShow = false
  return self
end

function StartUI:show()
  self.isShow = true
  state.Interface:draw()
end

function StartUI:hide()
  self.isShow = false
  state.Interface:draw()
end

function StartUI:getXml()
  if (not self.isShow) then return end
  local count = state.Game.maxRounds
  return {
    tag="VerticalLayout",
    attributes={ childAlignment="UpperLeft", height=200, width=500, outlineSize="5 5", childForceExpandHeight=false},
    children={{
      tag="Panel",
      attributes={ color="Black", rectAlignment="LowerCenter", outline="Black", outlineSize="5 5", preferredHeight=100 },
      children = {{
        tag="Text",
        attributes={ id="startText1", text="Play with seated players for ".. tostring(count) .. " rounds", color="White", fontSize=24 }
      }}
    }, {
      tag="Panel",
      attributes={ color="Black", outline="Black", outlineSize="5 5", preferredHeight=50, preferredWidth=400, padding="10 10 10 15" },
      children={{
        tag="Slider",
        attributes={ id="startSlider1", minValue="2", maxValue="15", value=count, wholeNumbers=true, onValueChanged="_startSlider"}
      }}
    }, {
      tag="Panel",
      attributes={ color="Black", outline="Black", outlineSize="5 5", preferredHeight=50, preferredWidth=400, spacing=10, padding="5 5 5 5" },
      children={{
        tag="Button",
        value="Cancel",
        attributes={ color="White", onClick="_cancelButtonClick", fontSize=24 }
      },{
        tag="Button",
        value = "Start",
        attributes={ color="White", onClick="_startButtonClick", fontSize=24 }
      }}
    }}
  }
end

function _startSlider(player, turns)
  state.Game.maxRounds = tonumber(turns)
  local text = "Play with seated players for ".. tostring(turns) .. " rounds"
  UI.setAttribute("startText1", "text", text)
end

function _cancelButtonClick()
  state.Interface.Start:hide()
end

function _startButtonClick()
  state.StartButton.obj.destruct()
  state.Interface.Start:hide()
  state.Player = {}
  for index, playerColor in ipairs(getSeatedPlayers()) do
    state.Player[playerColor] = SK_Player.create(playerColor, staticData.players[playerColor])
  end
  state.Game:startBidding()

  Turns.enable = true
  Turns.type = 2
  Turns.pass_turns = true
  Turns.turn_color = table.random(getSeatedPlayers())
  Turns.order = table.filter({ "White", "Red", "Yellow", "Green", "Blue", "Pink"},
    function(playerColor) table.find(
      getSeatedPlayers(),
      function(c) return c == playerColor end)
    end
  )
end
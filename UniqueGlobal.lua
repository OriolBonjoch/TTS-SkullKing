-- staticData.lua


-- savedData.lua
savedData = {
  round = 0,
  trick = 0,
  cards = {},
  suit = "",
  deck,
  chests = {},
  labels = {},
  votes = {},
  rounds = {},
  phase = "start"
}

state = {}

-- gameMode.lua
GameMode = {}

function GameMode:new(o, isHotSeat)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.isHotSeat = isHotSeat or false
  return o
end

function GameMode:start()
  Turns.order = createInitialOrder()
  Turns.pass_turns = false
  Turns.enable = self.isHotSeat
  if (self.isHotSeat) then
    Turns.type = 1
  else
    Turns.type = 2
  end
end


-- helpers.lua
function createInitialOrder()
  local tbl = getSeatedPlayers()
  local len, random = #tbl, math.random
  for i = len, 2, -1 do
      local j = random( 1, i )
      tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function getCurrentPlayerHandCardIds()
  function getCardId(obj)
    return obj.getGUID()
  end 

  return map(getCardId, Player[Turns.turn_color].getHandObjects(1))
end

function has_value (tab, val)
  for index, value in ipairs(tab) do
      if value == val then
          return true
      end
  end

  return false
end

function map(f, t)
  local t1 = {}
  local t_len = #t
  for i = 1, t_len do
      t1[i] = f(t[i])
  end
  return t1
end

-- chest.lua
function createChestButtons(obj, color)
  obj.createButton(
    {
      click_function = "chestClickedCallback",
      color = color,
      width = 370,
      height = 290,
      position = {x = 0, y = -0.2, z = 0}
    }
  )

  obj.createButton(
    {
      click_function = "chestSubmitCallback",
      color = color,
      width = 370,
      height = 290,
      label = "submit",
      position = {x = 0, y = 0, z = 1},
      rotation = {x = 0, y = 180, z = 0}
    }
  )
end

function chestDraw(playerColor)
  local data = staticData.players[playerColor]
  local chest =
    spawnObject(
    {
      type = "Tileset_Chest",
      position = data.chestPosition,
      rotation = data.chestRotation,
      scale = {x = 2, y = 2, z = 2},
      callback_function = function(obj)
        savedData.chests[playerColor] = obj.getGUID()
        obj.setLock(true)
        obj.setColorTint(data.chestColor)
        createChestButtons(obj, data.chestColor)
      end
    }
  )
end

function chestClickedCallback(obj, player_clicker_color, alt_click)
  if (not chestValidateObject(obj, player_clicker_color)) then
    return
  end

  local oldValue = savedData.votes[player_clicker_color]
  local newValue = oldValue
  if alt_click and oldValue > 0 then
    newValue = oldValue - 1
  elseif (not alt_click and oldValue < savedData.round) then
    newValue = oldValue + 1
  else
    return
  end

  savedData.votes[player_clicker_color] = newValue
  broadcastToColor("You voted " .. newValue, player_clicker_color, player_clicker_color)
end

function chestSubmitCallback(obj, player_clicker_color, alt_click)
  if (not chestValidateObject(obj, player_clicker_color)) then
    return
  end

  savedData.rounds[savedData.round][player_clicker_color].vote = savedData.votes[player_clicker_color]
  broadcastToAll(player_clicker_color .. " voted", player_clicker_color)
  obj.clearButtons()

  for index, playerColor in ipairs(getSeatedPlayers()) do
    if (savedData.rounds[savedData.round][playerColor].vote == -1) then
      return
    end
  end

  startRound()
end

function chestValidateObject(obj, player_clicker_color)
  if (savedData.chests[player_clicker_color] ~= obj.getGUID()) then
    return false
  end

  if (savedData.rounds[savedData.round][player_clicker_color].vote ~= -1) then
    return false
  end
  return true
end

-- deck.lua
function deckDraw()
  savedData.deck =
    spawnObject(
    {
      type = "DeckCustom",
      position = {x = 0, y = 5, z = 0},
      rotation = {x = 180, y = 0, z = 0}
    }
  )
  savedData.deck.setCustomObject(
    {
      face = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/deck.jpg",
      back = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/back.jpg",
      number = 66,
      width = 10,
      height = 7
    }
  )
  for index, cardData in ipairs(savedData.deck.getObjects()) do
    savedData.cards[cardData.guid] = staticData.cards[index]
  end
end

-- winsLabel.lua
function winsLabelDraw(playerColor)
  local data = staticData.players[playerColor]
  local label = spawnObject(
    {
      type = "3DText",
      position = data.labelPosition,
      rotation = data.labelRotation
    }
  )

  savedData.labels[playerColor] = label.getGUID()
  label.setLock(true)
  label.TextTool.setFontColor(playerColor)
  label.TextTool.setValue("0")
end

function winsLabelUpdate(playerColor)
  local label = getObjectFromGUID(savedData.labels[playerColor])
  label.TextTool.setValue(savedData.rounds[savedData.round][playerColor].wins)
end

-- startButton.lua
function startButtonClickedCallback(obj, player_clicker_color, alt_click)
  savedData.round = savedData.round + 1
  local roundData = {}
  for index, playerColor in ipairs(getSeatedPlayers()) do
    initPlayer(playerColor)
    savedData.deck.deal(savedData.round, playerColor)
    roundData[playerColor] = { vote = -1 }
    -- for _, data2 in ipairs(Player[playerColor].getHandObjects(1)) do
    --   local cardData2 = savedData.cards[data2.getGUID()]
    --   data2.setDescription(cardData2.name .. " - " .. cardData2.value)
    -- end
  end
  table.insert(savedData.rounds, savedData.round, roundData)
end

function startButtonDraw()
  local button =
    spawnObject(
    {
      type = "Custom_Model",
      position = {x = 0, y = 1.2, z = -5},
      rotation = {x = 0, y = 180, z = 0},
      callback_function = function(obj)
        obj.setColorTint(Color.Grey)
        obj.setLock(true)
        obj.createButton(
          {
            click_function = "startButtonClickedCallback",
            label = "Start",
            width = 400,
            height = 300,
            font_size = 100,
            position = {x = 0, y = 0.27, z = 0},
            color = {0.5, 0.5, 0.5},
            font_color = {1, 1, 1}
          }
        )
      end
    }
  )

  button.setCustomObject(
    {
      mesh = "https://github.com/OriolBonjoch/TTS-SkullKing/raw/main/data/botonazito_dividido_2mm_origen.obj",
      material = 1,
      convex = true
    }
  )
end

-- gameLogic.lua
function initPlayer(playerColor)
  savedData.votes[playerColor] = 0
  chestDraw(playerColor)
end

function calculateWinner()
-- suit should be an argument to this function as we need to block the playable cards
  broadcastToAll("Calculating winner", Color.White)
  -- nos olvidamos de sirena > rey pirata, scary mary = pirata y de los puntos extras de sirena y rey pirata

  local suitPriority = { "bandera", "sirena", "pirata", "scary mary", "rey pirata" }

  local winner = ""
  local suit = ""
  local highestValue = -1
  for index, playerColor in ipairs(Turns.order) do
    local cardId = savedData.rounds[savedData.round][playerColor].cards[savedData.trick]
    local cardData = savedData.cards[cardId]
    if (not suit and has_value({ "mapa", "cofre", "loro", "bandera"}, cardData.name)) then
      suit = cardData.name
    end
    if (index == 0) then
      winner = playerColor
    end
    if (cardData.name == suit) then
      if (cardData.value > highestValue) then
        winner = playerColor
        highestValue = cardData.value
      end
    else
      if (has_value(suitPriority, cardData.name)) then
        if (cardData.value > highestValue) then
          winner = playerColor
          highestValue = cardData.value
        end
      end
    end
  end

  broadcastToAll("Winner of this round: " .. winner, Color.White)
  return winner
end

function startRound()
  for index, playerColor in ipairs(getSeatedPlayers()) do
    savedData.rounds[savedData.round][playerColor].cards = {}
    printToAll("Player " .. playerColor .. " voted " .. savedData.votes[playerColor], playerColor)
    winsLabelDraw(playerColor)
  end

  savedData.trick = savedData.round
  Turns.enable = true
  startTrick()
end

function startTrick()
  savedData.suit = ""
end

function endTrick()
  broadcastToAll("Trick finished! calculate winner", playerColor)
  local winner = calculateWinner()
  for index, player_color in ipairs(getSeatedPlayers()) do
    local cardId = savedData.rounds[savedData.round][player_color].cards[savedData.trick]
    local card = getObjectFromGUID(cardId)
    card.destruct()
  end

  savedData.rounds[savedData.round][player_color].wins = savedData.rounds[savedData.round][player_color].wins + 1
  victoriesLabelUpdate(player_color)

  -- subir puntos (rey pirata o sirena)

  savedData.trick = savedData.trick - 1
  if (savedData.trick == 0) then
    broadcastToAll("TODO: Bid again", Color.White)
    Turns.enable = false
  end
end

-- global.lua
function onObjectDrop(playerColor, obj)
  if Turns.turn_color ~= playerColor then 
    -- broadcastToColor("Is not your turn", playerColor, colorName)
    return
  end

  if (has_value(getCurrentPlayerHandCardIds(), obj.getGUID())) then
    return
  end
  
  local data = savedData.cards[obj.getGUID()]
  if (not savedData.suit and has_value({ "mapa", "cofre", "loro", "bandera"}, data.name)) then
    savedData.suit = data.name
  end
  printToAll(data.name .. " - " .. data.value, playerColor)
  table.insert(savedData.rounds[savedData.round][playerColor].cards, savedData.trick, obj.getGUID())
end

function onLoad()
  for index, data in ipairs(getAllObjects()) do
    data.destruct()
  end

  -- state.Mode = GameMode:create(nil, true)
  startButtonDraw()
  deckDraw()
  savedData.deck.shuffle()
  -- state.Mode.start()  
  Turns.order = createInitialOrder()
  Turns.pass_turns = false
  Turns.enable = false
  Turns.type = 2
end

-- helper function to avoid cheating
-- TO FIX: DOES NOT WORK
-- function onObjectPickUp( player_color, obj)
--   -- check if is a card
--   -- chekc if there is suit
--   -- check if is different from suit
--   print(Turns.enable)
--   print(Turns.turn_color)
--   print(player_color)
--   if (not Turns.enable or Turns.turn_color ~= player_color) then 
--     obj.drop()
--     return
--   end

--   local cardId = obj.getGUID()
--   local cardData = savedData.cards[cardId]
--   if (not cardData) then
--     return
--   end
  
--   function convertToCard(obj)
--     local cardId = obj.getGUID()
--     return savedData.cards[cardId].name
--   end 

--   print("Hemos llegado")
--   cardsInHand = map(convertToCard, Player[player_color].getHandObjects(1))
--   if (savedData.suit and savedData.suit ~= cardData.name and not has_value(staticData.isFigure, cardData.name) and has_value(cardsInHand, savedData.suit)) then
--     obj.drop()
--   end
-- end

function onPlayerTurn(person)
  if (not savedData.rounds[savedData.round]) then
    return
  end

  for index, player_color in ipairs(getSeatedPlayers()) do
    if (not savedData.rounds[savedData.round][player_color] or savedData.rounds[savedData.round][player_color].vote == -1) then
      return
    end
  end

  for index, player_color in ipairs(getSeatedPlayers()) do
    if (not savedData.rounds[savedData.round][player_color].cards[savedData.trick]) then
      return
    end
  end
  print(person.color .. "'s turn starts now.")

  endTrick()
  startTrick()
end
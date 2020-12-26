function createInitialOrder()
  local tbl = getSeatedPlayers()
  local len, random = #tbl, math.random
  for i = len, 2, -1 do
      local j = random( 1, i )
      tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function getCurrentPlayerHandCardIds(playerColor)
  function getCardId(obj)
    return obj.getGUID()
  end 

  return map(getCardId, Player[playerColor].getHandObjects(1))
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
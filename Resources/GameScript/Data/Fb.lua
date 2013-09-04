--副本数据存储
DATA_Fb = {}

local _data
function DATA_Fb:set(data)
  _data = data
end

function DATA_Fb:setByKey(first, second, third)
  if not _data then
    _data = {}
  end
  
  if third then
    if not _data[first] then
      _data[first] = {}
    end
    _data[first][second] = third
  else
    _data[first] = second
  end
end


function DATA_Fb:get(...)
  local result = _data
  for i = 1, arg["n"] do
    result = result[arg[i]]
    if not result then
--      dump(_data[arg[1]])
--      dump(arg)   
--      print(arg[i],"取到resut为空")
      break
    end
  end
  return result
end
function dump(base, req)
  if type(base) == 'table' then
    local s = '{ '
    for k,v in pairs(base) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(base)
  end
end

function safe_dump(base, req)
  local status, result = pcall(function() return dump(base) end)
  if status then
    return result
  else
    return 'Error: ' .. tostring(result)
  end
end

function simple_dump(base, req) return 'SUCCESS' end

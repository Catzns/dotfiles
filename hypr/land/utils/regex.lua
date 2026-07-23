local REGEX = {}

-- c: Concatenate - OR regexes together with minimal syntax
---@param regexes string[]
---@return string
function REGEX.c(regexes)
  if #regexes < 1 then
    return ''
  end
  local r = string.format('(%s)', regexes[1])
  for i = 2, #regexes do
    r = string.format('%s|(%s)', r, regexes[i])
  end
  return r
end

-- n: Negative - Target objects that do not match the input regex
---@param s string
---@return string
function REGEX.n(s)
  return 'negative:' .. s
end

return REGEX

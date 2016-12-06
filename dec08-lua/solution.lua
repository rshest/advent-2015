function getUnescapedLen(s)
  local patterns = {"\\\\", "\\x..", "\\\""}
  -- remove the quotes at the ends
  local unescaped = string.sub(s, 2, -2)
  for i, p in ipairs(patterns) do
    unescaped = string.gsub(unescaped, p, "?")
  end
  return string.len(unescaped)
end

function getEscapedLen(s)
  local escaped = s
  escaped = string.gsub(escaped, "\"", "??")
  escaped = string.gsub(escaped, "\\", "??")
  return string.len(escaped) + 2
end

local diff1 = 0
local diff2 = 0

local file = arg[1] or 'input.txt'
for line in io.lines(file) do 
  diff1 = diff1 + (string.len(line) - getUnescapedLen(line))
  diff2 = diff2 + (getEscapedLen(line) - string.len(line))
end

print("Unescaped character count diff:", diff1)
print("Escaped character count diff:", diff2)
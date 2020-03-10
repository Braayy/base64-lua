getmetatable('').__index = function(str, i) return string.sub(str, i, i) end

local function bin(n, min_bits_length)
  local function bin_divide(n, stack)
    if n == 0 then return end

    local rest = n % 2
    table.insert(stack, rest)

    bin_divide(math.floor(n / 2), stack)
  end

  local function bin_fill_zeros(stack, min_bits_length)
    if #stack >= min_bits_length then return stack end

    table.insert(stack, 0)
    return bin_fill_zeros(stack, min_bits_length)
  end

  local function bin_revert(stack)
    local new_stack = {}

    for i = 1, #stack do
      new_stack[i] = stack[#stack - i + 1]
    end

    return new_stack
  end
  
  min_bits_length = min_bits_length or 8

  local stack = {}
  bin_divide(n, stack)

  bin_fill_zeros(stack, min_bits_length)
  stack = bin_revert(stack)
  return stack
end

local function concat(t1, t2)
  local concat = {}

  for i = 1, #t1 do
    table.insert(concat, t1[i])
  end

  for i = 1, #t2 do
    table.insert(concat, t2[i])
  end

  return concat
end

-- http://lua-users.org/wiki/StringRecipes
local function endswith(str, ending)
   return ending == "" or string.sub(str, -#ending) == ending
end

local function fill_with(str, char, length)
  local function fill()
    if #str == length then return end
    
    str = str .. char
    fill(str)
  end
  
  fill()
  
  return str
end

return {
  bin = bin,
  concat = concat,
  endswith = endswith,
  fill_with = fill_with
}

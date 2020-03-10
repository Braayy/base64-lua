local utils = require('./utils')

function print_table(tb)
  for _, v in pairs(tb) do
    print(tostring(v))
  end
  
  print()
end

local function generate_b64_table()
  local b64_table = {}

  for i = 65, 90 do
    table.insert(b64_table, string.char(i))
    b64_table[string.char(i)] = #b64_table
  end

  for i = 97, 122 do
    table.insert(b64_table, string.char(i))
    b64_table[string.char(i)] = #b64_table
  end

  for i = 0, 9 do
    table.insert(b64_table, tostring(i))
    b64_table[tostring(i)] = #b64_table
  end

  table.insert(b64_table, '+')
  table.insert(b64_table, '/')
  
  b64_table['+'] = #b64_table - 1
  b64_table['/'] = #b64_table

  return b64_table
end

local b64_table = generate_b64_table()

local function b64_encode(str)
  local bin_chain = {}
  for i = 1, #str do
    local bin_stack = utils.bin(string.byte(str[i]))

    bin_chain = utils.concat(bin_chain, bin_stack)
  end

  local separated = {}
  for i = 1, #bin_chain, 6 do
    local six = {}
    for j = 1, 6 do
      six[j] = bin_chain[i+j-1]
    end

    table.insert(separated, table.concat(six))
  end
  
  if #separated[#separated] < 6 then
    separated[#separated] = utils.fill_with(separated[#separated], '0', 6)
  end

  local b64 = {}
  for i = 1, #separated do
    local dec = tonumber(separated[i], 2)
    local b64_char = b64_table[dec+1]

    table.insert(b64, b64_char)
  end

  table.insert(b64, '==')

  return table.concat(b64)
end

local function b64_decode(str)
  if utils.endswith(str, '==') then
    str = string.sub(str, 0, #str - 2)
  elseif utils.endswith(str, '=') then
    str = string.sub(str, 0, #str - 1)
  end
  
  local bin_chain = {}
  
  for i = 1, #str do
    local b64_index = b64_table[str[i]] - 1
    local bin_stack = utils.bin(b64_index, 6)
    
    bin_chain = utils.concat(bin_chain, bin_stack)
  end
  
  local separated = {}
  for i = 1, #bin_chain, 8 do
    local eight = {}
    for j = 1, 8 do
      eight[j] = bin_chain[i+j-1]
    end

    table.insert(separated, table.concat(eight))
  end
  
  local ascii = {}
  for i = 1, #separated do
    local dec = tonumber(separated[i], 2)
    local ascii_char = string.char(dec)

    table.insert(ascii, ascii_char)
  end
  
  return table.concat(ascii)
end

local function main()
  print('B64 Impl in lua by Braayy')
  print()
  
  if #arg <= 1 then
    print('\t-e <string-to-encode>')
    print('\t-d <string-to-decode>')
    return
  end
  
  if arg[1] == '-e' then
    local result = b64_encode(arg[2])
    
    print('b64 encoded: ' .. result)
  elseif arg[1] == '-d' then
    local result = b64_decode(arg[2])
    
    print('b64 decoded: ' .. result)
  end
end

main()

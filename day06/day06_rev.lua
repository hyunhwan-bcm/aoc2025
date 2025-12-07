-- Advent of Code 2025 - Day 6
--
-- https://adventofcode.com/2025/day/6

local function read_input(filename)
  local lines = {}
  local file = io.open(filename, "r")
  if not file then

    error("Could not open file: " .. filename)
  end

  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

local function split_wspace(line)
  local t = {}
  for tok in line:gmatch("%S+") do
    table.insert(t, tok)
  end
  return t
end

local function has_operators(tb)
  for _,v in ipairs(tb) do
    if v == "*" or v == '+' then
      return true
    end
  end
  return false
end


local function calculate(numbers, operator)
  local n = #numbers
  local ret = 0

  for i=1,n do
    local ans = numbers[i][1]
    for j=2,#numbers[i] do
      if operator[i] == '*' then
        ans = ans * numbers[i][j]
      else
        ans = ans + numbers[i][j]
      end
    end
    ret = ret + ans
  end
  return ret
end

local function reverse(t)
  local i,j=1, #t
  while i<j do
    t[i], t[j] = t[j], t[i]
    i = i+1
    j = j-1
  end
end

local function transpose(inp)
  local t = {}
  local n = #inp
  local m = #inp[1]

  for c = 1,m do
    t[c] = {}
    for r = 1,n do
      t[c][r] = inp[r][c]
    end
  end

  return t
end

local function rotate(inp)
  local t = {}
  local n = #inp
  local m = #inp[1] for c = 1,m do t[m-c+1] = {}
    for r = 1,n do
      t[m-c+1][r] = inp[r][c]
    end
  end

  return t
end

local function part1(input)
  -- TODO: Implement part 1
  local numbers = {}
  local operator = {}
  for _,line in ipairs(input) do
    line = split_wspace(line)
    if has_operators(line) then
      operator = line
      break
    end
    for i=1,#line do
      line[i] = tonumber(line[i])
    end
    table.insert(numbers, line)
  end
  numbers = transpose(numbers)
  return calculate(numbers, operator)
end

-- Part 2
local function part2(input)
  -- TODO: Implement part 2
  local numbers = {}
  local operator = {}
  for _,line in ipairs(input) do
    local temp = split_wspace(line)
    if has_operators(temp) then
      operator = temp
      reverse(temp)
      break
    end

    local str = {}
    for i=1,#line do
      table.insert(str, line:sub(i,i))
    end
    table.insert(numbers, str)
  end

  numbers = rotate(numbers)

  local buf = {}
  local converted_numbers = {}
  for _,line in pairs(numbers) do
    local num = table.concat(line)
    num = num:match("^%s*(.-)%s*$")
    if #num == 0 then
      table.insert(converted_numbers, buf)
      buf = {}
    else
      table.insert(buf, tonumber(num))
    end
  end
  if #buf > 0 then
    table.insert(converted_numbers,buf)
  end

  return calculate(converted_numbers, operator)
end

-- Main execution
local function main()
  local filename = arg[1] or "input.txt"
  local input = read_input(filename)

  local result1 = part1(input)
  print("Part 1: " .. result1)

  local result2 = part2(input)
  print("Part 2: " .. result2)
end

main()

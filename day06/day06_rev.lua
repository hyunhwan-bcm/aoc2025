-- Advent of Code 2025 - Day 6
--
-- https://adventofcode.com/2025/day/6

local function read_input(filename)
  local file = assert(io.open(filename, "r"), "Could not open file: " .. filename)
  local lines = {}
  for line in file:lines() do
    lines[#lines + 1] = line
  end
  file:close()
  return lines
end

local function split_wspace(line)
  local t = {}
  for tok in line:gmatch("%S+") do
    t[#t + 1] = tok
  end
  return t
end

local function has_operators(tb)
  for _, v in ipairs(tb) do
    if v == "*" or v == "+" then return true end
  end
  return false
end


local function calculate(numbers, operators)
  local sum = 0
  for i, nums in ipairs(numbers) do
    local result = nums[1]
    for j = 2, #nums do
      result = operators[i] == "*" and result * nums[j] or result + nums[j]
    end
    sum = sum + result
  end
  return sum
end

local function reverse(t)
  local i, j = 1, #t
  while i < j do
    t[i], t[j] = t[j], t[i]
    i, j = i + 1, j - 1
  end
end

local function transpose(inp)
  local t = {}
  for c = 1, #inp[1] do
    t[c] = {}
    for r = 1, #inp do
      t[c][r] = inp[r][c]
    end
  end
  return t
end

local function rotate(inp)
  local t = {}
  local m = #inp[1]
  for c = 1, m do
    t[m - c + 1] = {}
    for r = 1, #inp do
      t[m - c + 1][r] = inp[r][c]
    end
  end
  return t
end

local function part1(input)
  local numbers, operators = {}, {}
  
  for _, line in ipairs(input) do
    local tokens = split_wspace(line)
    if has_operators(tokens) then
      operators = tokens
      break
    end
    local nums = {}
    for i = 1, #tokens do
      nums[i] = tonumber(tokens[i])
    end
    numbers[#numbers + 1] = nums
  end
  
  return calculate(transpose(numbers), operators)
end

local function part2(input)
  local chars, operators = {}, {}
  
  for _, line in ipairs(input) do
    local tokens = split_wspace(line)
    if has_operators(tokens) then
      operators = tokens
      reverse(operators)
      break
    end
    local row = {}
    for i = 1, #line do
      row[i] = line:sub(i, i)
    end
    chars[#chars + 1] = row
  end
  
  local rotated = rotate(chars)
  local numbers, buf = {}, {}
  
  for _, line in ipairs(rotated) do
    local str = table.concat(line):match("^%s*(.-)%s*$")
    if #str == 0 then
      if #buf > 0 then
        numbers[#numbers + 1] = buf
        buf = {}
      end
    else
      buf[#buf + 1] = tonumber(str)
    end
  end
  if #buf > 0 then
    numbers[#numbers + 1] = buf
  end
  
  return calculate(numbers, operators)
end

local function main()
  local filename = arg[1] or "input.txt"
  local input = read_input(filename)
  
  print("Part 1: " .. part1(input))
  print("Part 2: " .. part2(input))
end

main()

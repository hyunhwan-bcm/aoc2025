-- Advent of Code 2025 - Day 2 (Leveled/Optimized)
-- https://adventofcode.com/2025/day/2

local function read_lines(fname)
  local lines = {}
  local file = io.open(fname, "r")
  if not file then
    error("Could not open file: " .. fname)
  end
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

local function split(str, delimiter)
  local result = {}
  for token in string.gmatch(str, string.format("([^%s]+)", delimiter)) do
    table.insert(result, token)
  end
  return result
end

local function part1(input)
  local ids = table.concat(input)
  local ans = 0
  
  for range in string.gmatch(ids, '[%d]+-[%d]+') do
    local numbers = split(range, "-")
    local lo, hi = tonumber(numbers[1]), tonumber(numbers[2])
    
    for i = lo, hi do
      local s = tostring(i)
      local n = #s
      if n % 2 == 0 and s:sub(1, n/2) == s:sub(n/2 + 1) then
        ans = ans + i
      end
    end
  end
  
  return ans
end

local function is_repeated_pattern(s, n)
  for j = 1, n - 1 do
    if n % j == 0 then
      local is_pattern = true
      for k = 1, n, j do
        if s:sub(1, j) ~= s:sub(k, k + j - 1) then
          is_pattern = false
          break
        end
      end
      if is_pattern then return tonumber(s) end
    end
  end
  return 0
end

local function part2(input)
  local ids = table.concat(input)
  local ans = 0
  
  for range in string.gmatch(ids, '[%d]+-[%d]+') do
    local numbers = split(range, "-")
    local lo, hi = tonumber(numbers[1]), tonumber(numbers[2])
    
    for i = lo, hi do
      local s = tostring(i)
      ans = ans + is_repeated_pattern(s, #s)
    end
  end
  
  return ans
end

local function main()
  local fname = arg[1] or "input.txt"
  local lines = read_lines(fname)
  print("Part 1:", part1(lines))
  print("Part 2:", part2(lines))
end

main()

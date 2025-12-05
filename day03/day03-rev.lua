-- Advent of Code 2025 - Day 3 (Leveled/Optimized)
-- https://adventofcode.com/2025/day/3

local function read_lines(fname)
  local lines = {}
  local file = io.open(fname, "r")
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

local function part1(input)
  local ans = 0
  
  for _, line in ipairs(input) do
    local n = #line
    local max_val = 0
    
    for i = 1, n - 1 do
      for j = i + 1, n do
        local cand = tonumber(line:sub(i, i) .. line:sub(j, j))
        if cand and cand > max_val then
          max_val = cand
        end
      end
    end
    
    ans = ans + max_val
  end
  
  return ans
end

local function part2(input)
  local ans = 0
  
  for _, line in ipairs(input) do
    local digits = {}
    for i = 1, #line do
      digits[i] = line:byte(i) - 48
    end
    
    local n = #line
    local best = 0
    local start = 0
    
    for i = 12, 1, -1 do
      start = start + 1
      local j = start
      local best_digit = digits[start]
      local best_pos = start
      
      while n - j + 1 >= i do
        if digits[j] > best_digit then
          best_digit = digits[j]
          best_pos = j
        end
        j = j + 1
      end
      
      best = best * 10 + best_digit
      start = best_pos
    end
    
    ans = ans + best
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

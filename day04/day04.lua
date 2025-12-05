-- Advent of Code 2025 - Day 4 (Leveled/Optimized)
-- https://adventofcode.com/2025/day/4

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

local function build_map(input)
  local map = {}
  for i, line in ipairs(input) do
    map[i] = {}
    for j = 1, #line do
      map[i][j] = line:sub(j, j)
    end
  end
  return map
end

local function count_neighbors(map, i, j, n, m)
  local count = 0
  for di = -1, 1 do
    for dj = -1, 1 do
      local ni, nj = i + di, j + dj
      if ni >= 1 and ni <= n and nj >= 1 and nj <= m and map[ni][nj] == "@" then
        count = count + 1
      end
    end
  end
  return count
end

local function part1(input)
  local map = build_map(input)
  local n, m = #map, #map[1]
  local ans = 0
  
  for i = 1, n do
    for j = 1, m do
      if map[i][j] == "@" and count_neighbors(map, i, j, n, m) <= 4 then
        ans = ans + 1
      end
    end
  end
  
  return ans
end

local function part2(input)
  local map = build_map(input)
  local n, m = #map, #map[1]
  local ans = 0
  
  while true do
    local to_remove = {}
    
    for i = 1, n do
      for j = 1, m do
        if map[i][j] == "@" and count_neighbors(map, i, j, n, m) <= 4 then
          table.insert(to_remove, {i, j})
        end
      end
    end
    
    if #to_remove == 0 then break end
    
    for _, pos in ipairs(to_remove) do
      map[pos[1]][pos[2]] = '.'
    end
    
    ans = ans + #to_remove
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

-- Advent of Code 2025 - Day 8
-- https://adventofcode.com/2025/day/8

local function read_input(filename)
  local file = assert(io.open(filename, "r"), "Could not open file: " .. filename)
  local lines = {}
  for line in file:lines() do
    lines[#lines + 1] = line
  end
  file:close()
  return lines
end

local function get_coordinate(line)
  local t = {}
  for tok in line:gmatch("%d+") do
    t[#t + 1] = tonumber(tok)
  end
  return t
end

local function get_distance(x, y)
  return (x[1]-y[1])^2 + (x[2]-y[2])^2 + (x[3]-y[3])^2
end
-- Part

local function get_parent(parent, i)
  return parent[i] == i and i or get_parent(parent, parent[i])
end

local function get_count(parent, count, i)
  return count[get_parent(parent, i)]
end

local function update(parent, count, to, from)
  local parent_from = get_parent(parent, from)
  local parent_to = get_parent(parent, to)

  parent[parent_to] = parent_from
  count[parent_from] = count[parent_from] + count[parent_to]
  count[parent_to] = 0
end

local function part1(org_input)
  -- TODO: Implement part 1
  local input = {}
  for i=1,#org_input do
    input[i] = get_coordinate(org_input[i])
  end

  local dist = {}
  for i=1,#input do
    for j=i+1,#input do
      table.insert(dist,{get_distance(input[i],input[j]),i,j})
    end
  end
  table.sort(dist, function(a,b)
    return a[1] < b[1]
  end)

  local parent, count = {}, {}
  for i=1,#input do
    parent[i] = i
    count[i] = 1
  end

  local num_iter = 1000
  if #input == 20 then
    num_iter = 10
  end
  for i=1,num_iter do
    local a,b = dist[i][2], dist[i][3]
    if get_parent(parent, a) ~= get_parent(parent, b) then
      if get_count(parent, count, a) > get_count(parent, count, b) then
        update(parent, count, a, b)
      else
        update(parent, count, b, a)
      end

    end
  end



  local counted = {}
  for i=1,#input do
    if i == get_parent(parent, i) then
      counted[#counted+1] = count[i]
    end
  end

  table.sort(counted, function(a,b)
    return a > b
  end)

  return counted[1] * counted[2] * counted[3]
end

local function part2(org_input)
  -- TODO: Implement part 1
  local input = {}
  for i=1,#org_input do
    input[i] = get_coordinate(org_input[i])
  end

  local dist = {}
  for i=1,#input do
    for j=i+1,#input do
      table.insert(dist,{get_distance(input[i],input[j]),i,j})
    end
  end
  table.sort(dist, function(a,b)
    return a[1] < b[1]
  end)

  local parent, count = {}, {}
  for i=1,#input do
    parent[i] = i
    count[i] = 1
  end

  for i=1,#dist do
    local a,b = dist[i][2], dist[i][3]
    if get_parent(parent, a) ~= get_parent(parent, b) then
      if get_count(parent, count, a) > get_count(parent, count, b) then
        update(parent, count, a, b)

        if get_count(parent, count, a) == #input then
          return input[a][1] * input[b][1]
        end
      else
        update(parent, count, b, a)
        if get_count(parent, count, b) == #input then
          return input[a][1] * input[b][1]
        end
      end

    end
  end

  return 0
end


-- Main execution
local function main()
  local filename = arg[1] or "input.txt"
  local input = read_input(filename)
  
  print("Part 1: " .. part1(input))
  print("Part 2: " .. part2(input))
end

main()

-- Advent of Code 2025 - Day 12
-- https://adventofcode.com/2025/day/12

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

local function parse_patterns_and_tests(input)
  local P = {}
  local A = {}

  local i = 1
  while i <= #input do
    local line = input[i]

    local pattern_id = line:match("^(%d+):$")
    if pattern_id then
      pattern_id = tonumber(pattern_id)
      P[pattern_id] = {}
      i = i + 1

      while i <= #input and input[i] ~= "" and not input[i]:match("^%d+:$") and not input[i]:match("^%d+x%d+:") do
        P[pattern_id][#P[pattern_id] + 1] = input[i]
        i = i + 1
      end
    elseif line:match("^%d+x%d+:") then
      local size_part, counts_part = line:match("^(%d+x%d+):%s*(.*)$")
      local a, b = size_part:match("^(%d+)x(%d+)$")
      a, b = tonumber(a), tonumber(b)

      local counts = {}
      for num in counts_part:gmatch("%S+") do
        counts[#counts + 1] = tonumber(num)
      end

      A[#A + 1] = {
        width = a,
        height = b,
        counts = counts
      }
      i = i + 1
    else
      i = i + 1
    end
  end

  return P, A
end

local function rotate_pattern(pattern)
  local rows = #pattern
  local cols = #pattern[1]
  local rotated = {}
  for c = 1, cols do
 local row = ""
    for r = rows, 1, -1 do
      row = row .. pattern[r]:sub(c, c)
    end
    rotated[#rotated + 1] = row
  end
  return rotated
end

local function flip_pattern(pattern)
  local flipped = {}
  for i = 1, #pattern do
    flipped[i] = pattern[i]:reverse()
  end
  return flipped
end

local function get_all_transformations(pattern)
  local transforms = {}
  local current = pattern

  for flip = 0, 1 do
    for rot = 0, 3 do
      local copy = {}
      for i = 1, #current do
        copy[i] = current[i]
      end
      transforms[#transforms + 1] = copy
      current = rotate_pattern(current)
    end
    current = flip_pattern(current)
  end

  return transforms
end

local function can_place_pattern(grid, pattern, row, col)
  local pat_rows = #pattern
  local pat_cols = #pattern[1]
  local grid_rows = #grid
  local grid_cols = #grid[1]

  if row + pat_rows - 1 > grid_rows or col + pat_cols - 1 > grid_cols then
    return false
  end

  for pr = 1, pat_rows do
    for pc = 1, pat_cols do
      if pattern[pr]:sub(pc, pc) == '#' then
        if grid[row + pr - 1]:sub(col + pc - 1, col + pc - 1) == '#' then
          return false
        end
      end
    end
  end

  return true
end

local function place_pattern_on_grid(grid, pattern, row, col)
  local new_grid = {}
  for i = 1, #grid do
    new_grid[i] = grid[i]
  end

  for pr = 1, #pattern do
    for pc = 1, #pattern[1] do
      if pattern[pr]:sub(pc, pc) == '#' then
        local gr = row + pr - 1
        local gc = col + pc - 1
        local line = new_grid[gr]
        new_grid[gr] = line:sub(1, gc - 1) .. '#' .. line:sub(gc + 1)
      end
    end
  end

  return new_grid
end

local call_count = 0
local memo = {}

local function make_state_key(grid, remaining_counts)
  local grid_str = table.concat(grid, "|")
  local counts_parts = {}
  for id = 0, 10 do
    if remaining_counts[id] and remaining_counts[id] > 0 then
      counts_parts[#counts_parts + 1] = id .. ":" .. remaining_counts[id]
    end
  end
  return grid_str .. "#" .. table.concat(counts_parts, ",")
end

local function count_pattern_cells(pattern)
  local count = 0
  for _, row in ipairs(pattern) do
    for c = 1, #row do
      if row:sub(c, c) == '#' then
        count = count + 1
      end
    end
  end
  return count
end

local function try_place_all_patterns(grid, P, remaining_counts, i, j)
  call_count = call_count + 1

  -- Check memoization
  local state_key = make_state_key(grid, remaining_counts)
  if memo[state_key] ~= nil then
    return memo[state_key]
  end

  -- Check if all patterns are placed
  local all_used = true
  for _, count in pairs(remaining_counts) do
    if count > 0 then
      all_used = false
      break
    end
  end

  if all_used then
    print("Found solution! Total calls: " .. call_count)
    memo[state_key] = true
    return true
  end

  -- Branch and bound: count empty cells vs cells needed
  local empty_cells = 0
  for _, row in ipairs(grid) do
    for c = 1, #row do
      if row:sub(c, c) == '.' then
        empty_cells = empty_cells + 1
      end
    end
  end

  local cells_needed = 0
  for pattern_id, count in pairs(remaining_counts) do
    if count > 0 then
      cells_needed = cells_needed + count * count_pattern_cells(P[pattern_id])
    end
  end

  if cells_needed > empty_cells then
    memo[state_key] = false
    return false
  end

  -- Find the first pattern type that still needs to be placed
  local current_pattern_id = nil
  for id = 0, 10 do
    if remaining_counts[id] and remaining_counts[id] > 0 then
      current_pattern_id = id
      break
    end
  end

  if current_pattern_id == nil then
    return false
  end

  -- Check if this is a new pattern type (different from previous recursion level)
  -- If so, restart from (1,1)
  local search_i, search_j = i, j

  -- Find next empty cell starting from (search_i, search_j)
  local row, col = nil, nil
  for r = search_i, #grid do
    local c_start = (r == search_i) and search_j or 1
    for c = c_start, #grid[1] do
      if grid[r]:sub(c, c) == '.' then
        row, col = r, c
        break
      end
    end
    if row then break end
  end

  if row == nil then
    return false
  end

  -- Try to place the current pattern type
  local pattern = P[current_pattern_id]
  local transforms = get_all_transformations(pattern)

  for _, transform in ipairs(transforms) do
    for offset_r = 0, #transform - 1 do
      for offset_c = 0, #transform[1] - 1 do
        if transform[offset_r + 1]:sub(offset_c + 1, offset_c + 1) == '#' then
          local place_row = row - offset_r
          local place_col = col - offset_c

          if place_row >= 1 and place_col >= 1 then
            if can_place_pattern(grid, transform, place_row, place_col) then
              local new_grid = place_pattern_on_grid(grid, transform, place_row, place_col)
              local new_counts = {}
              for id, c in pairs(remaining_counts) do
                new_counts[id] = c
              end
              new_counts[current_pattern_id] = new_counts[current_pattern_id] - 1

              -- If we just finished placing all of this pattern type, restart from (1,1)
              -- Otherwise continue from current position
              local next_i, next_j
              if new_counts[current_pattern_id] == 0 then
                next_i, next_j = 1, 1
              else
                next_i, next_j = row, col
              end

              if try_place_all_patterns(new_grid, P, new_counts, next_i, next_j) then
                memo[state_key] = true
                return true
              end
            end
          end
        end
      end
    end
  end

  -- If no pattern could be placed at this cell, skip it and try the next cell
  local next_col = col + 1
  local next_row = row
  if next_col > #grid[1] then
    next_col = 1
    next_row = next_row + 1
  end

  if try_place_all_patterns(grid, P, remaining_counts, next_row, next_col) then
    memo[state_key] = true
    return true
  end

  memo[state_key] = false
  return false
end

-- Part 1
local function part1(input)
  P, A = parse_patterns_and_tests(input)

  local count = 0

  for idx, test_case in ipairs(A) do
    call_count = 0
    memo = {}

    local grid = {}
    for r = 1, test_case.height do
      grid[r] = string.rep(".", test_case.width)
    end

    local remaining_counts = {}
    for i, c in ipairs(test_case.counts) do
      remaining_counts[i - 1] = c
    end

    if try_place_all_patterns(grid, P, remaining_counts, 1, 1) then
      count = count + 1
    else
      print("Case " .. idx .. " FAILED (total calls: " .. call_count .. ")")
    end
  end

  return count
end

-- Part 2
local function part2(input)
  -- TODO: Implement part 2
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

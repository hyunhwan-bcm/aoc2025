local function read_lines(fname)
  local l = {}
  for line in io.open(fname, "r"):lines() do
    table.insert(l, line)
  end
  return l
end

local mod100 = function(x)  
  return ((x % 100) + 100) % 100
end

-- Count zeros hit while rotating from `cur` by `rot` steps.
-- dir = "R" for right, "L" for left.
local function zeros_in_move(cur, rot, dir)
  local first_hit
  if dir == "R" then
    first_hit = (100 - cur) % 100          -- first step that lands on 0
    if first_hit == 0 then first_hit = 100 end
  else                                      -- left
    first_hit = cur % 100
    if first_hit == 0 then first_hit = 100 end
  end

  return rot >= first_hit and math.floor((rot - first_hit) / 100) + 1 or 0
end

local function part1(lines)
  local cur, ans = 50, 0
  for _, l in ipairs(lines) do
    local dir = l:sub(1, 1)
    local rot = tonumber(l:sub(2))
    cur = mod100(cur + (dir == "R" and rot or -rot))
    if cur == 0 then ans = ans + 1 end
  end
  return ans
end

local function part2(lines)
  local cur, ans = 50, 0
  for _, l in ipairs(lines) do
    local dir = l:sub(1, 1)
    local rot = tonumber(l:sub(2))

    ans = ans + zeros_in_move(cur, rot, dir)

    cur = mod100(cur + (dir == "R" and rot or -rot))
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


#!/bin/bash

# Script to generate Advent of Code day template
# Usage: ./generate.sh <day_number>

if [ -z "$1" ]; then
    echo "Usage: ./generate.sh <day_number>"
    echo "Example: ./generate.sh 1"
    exit 1
fi

# Validate that the argument is a number
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be a number"
    echo "Usage: ./generate.sh <day_number>"
    exit 1
fi

DAY=$1
DAY_PADDED=$(printf "%02d" $DAY)
DIR_NAME="day${DAY_PADDED}"
FILE_NAME="${DIR_NAME}.lua"

# Check if directory already exists
if [ -d "$DIR_NAME" ]; then
    echo "Error: Directory $DIR_NAME already exists!"
    exit 1
fi

# Create and switch to new branch
BRANCH_NAME="day${DAY_PADDED}"
echo "Creating and switching to branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME" 2>/dev/null || git checkout "$BRANCH_NAME"

# Create directory
echo "Creating directory: $DIR_NAME"
mkdir -p "$DIR_NAME"

# Create main Lua file with template
cat > "$DIR_NAME/$FILE_NAME" << 'LUAEOF'
-- Advent of Code 2025 - Day DAY_NUM
-- https://adventofcode.com/2025/day/DAY_NUM

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

-- Part 1
local function part1(input)
  -- TODO: Implement part 1
  return 0
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
LUAEOF

# Replace DAY_NUM placeholder with actual day number
sed -i '' "s/DAY_NUM/$DAY/g" "$DIR_NAME/$FILE_NAME"

# Create empty input files
touch "$DIR_NAME/input.txt"
touch "$DIR_NAME/example.txt"

# Create .gitignore to exclude input.txt
cat > "$DIR_NAME/.gitignore" << 'EOF'
input.txt
EOF

echo ""
echo "Successfully created $DIR_NAME on branch $BRANCH_NAME with:"
echo "  - $FILE_NAME (solution template)"
echo "  - input.txt (empty, gitignored)"
echo "  - example.txt (empty)"
echo ""
echo "Next steps:"
echo "  1. cd $DIR_NAME"
echo "  2. Add your puzzle input to input.txt"
echo "  3. Add example input to example.txt"
echo "  4. Implement part1() and part2() in $FILE_NAME"
echo "  5. Run: lua $FILE_NAME example.txt"
echo "  6. Run: lua $FILE_NAME input.txt"

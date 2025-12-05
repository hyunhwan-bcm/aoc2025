# Lua Tables

Tables are Lua's only data structure. They can be used as arrays, dictionaries, sets, and objects.

## Arrays (Sequential Tables)

### Creating Arrays
```lua
-- Empty array
local arr = {}

-- Array with values
local colors = {"red", "green", "blue"}

-- Mixed types (not recommended but possible)
local mixed = {1, "two", true, 3.14}
```

### Accessing Elements
```lua
local colors = {"red", "green", "blue"}

-- Arrays are 1-indexed (not 0!)
print(colors[1])  -- "red"
print(colors[2])  -- "green"
print(colors[3])  -- "blue"

-- Out of bounds returns nil
print(colors[4])  -- nil
```

### Array Length
```lua
local colors = {"red", "green", "blue"}
print(#colors)  -- 3

-- Empty array
local empty = {}
print(#empty)  -- 0
```

### Adding Elements
```lua
local arr = {"a", "b", "c"}

-- Append to end
table.insert(arr, "d")
print(#arr)  -- 4

-- Insert at position
table.insert(arr, 2, "x")  -- Insert "x" at index 2
-- arr is now {"a", "x", "b", "c", "d"}
```

### Removing Elements
```lua
local arr = {"a", "b", "c", "d"}

-- Remove from end
local last = table.remove(arr)
print(last)  -- "d"
print(#arr)  -- 3

-- Remove at position
local second = table.remove(arr, 2)
print(second)  -- "b"
-- arr is now {"a", "c"}
```

### Iterating Arrays
```lua
local colors = {"red", "green", "blue"}

-- Using ipairs (array iteration)
for index, value in ipairs(colors) do
    print(index, value)
end
-- Output:
-- 1    red
-- 2    green
-- 3    blue

-- Using numeric for loop
for i = 1, #colors do
    print(i, colors[i])
end
```

## Dictionaries (Hash Tables)

### Creating Dictionaries
```lua
-- Empty dictionary
local dict = {}

-- Dictionary with values
local person = {
    name = "Alice",
    age = 30,
    city = "NYC"
}

-- Alternative syntax
local person2 = {
    ["name"] = "Bob",
    ["age"] = 25,
    ["city"] = "LA"
}
```

### Accessing Values
```lua
local person = {name = "Alice", age = 30}

-- Dot notation
print(person.name)  -- "Alice"
print(person.age)   -- 30

-- Bracket notation
print(person["name"])  -- "Alice"
print(person["age"])   -- 30

-- Non-existent keys return nil
print(person.job)  -- nil
```

### Adding/Modifying
```lua
local person = {name = "Alice"}

-- Add new key
person.age = 30
person["city"] = "NYC"

-- Modify existing
person.name = "Alice Smith"
```

### Removing Keys
```lua
local person = {name = "Alice", age = 30}

-- Set to nil to remove
person.age = nil
print(person.age)  -- nil
```

### Iterating Dictionaries
```lua
local person = {name = "Alice", age = 30, city = "NYC"}

-- Using pairs (dictionary iteration)
for key, value in pairs(person) do
    print(key, value)
end
-- Output (order not guaranteed):
-- name    Alice
-- age     30
-- city    NYC
```

## Mixed Tables

```lua
-- Table with both array and dictionary parts
local mixed = {
    "first",      -- [1] = "first"
    "second",     -- [2] = "second"
    name = "Bob", -- ["name"] = "Bob"
    count = 5     -- ["count"] = 5
}

print(mixed[1])      -- "first"
print(mixed[2])      -- "second"
print(mixed.name)    -- "Bob"
print(mixed.count)   -- 5

-- Length only counts array part
print(#mixed)  -- 2
```

## Nested Tables

```lua
-- 2D grid
local grid = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

print(grid[1][1])  -- 1
print(grid[2][3])  -- 6
print(grid[3][2])  -- 8

-- Nested dictionary
local data = {
    user = {
        name = "Alice",
        contact = {
            email = "alice@example.com",
            phone = "555-1234"
        }
    }
}

print(data.user.name)              -- "Alice"
print(data.user.contact.email)     -- "alice@example.com"
```

## Table Library Functions

### table.insert
```lua
local arr = {1, 2, 3}
table.insert(arr, 4)        -- append: {1, 2, 3, 4}
table.insert(arr, 2, 99)    -- insert at index 2: {1, 99, 2, 3, 4}
```

### table.remove
```lua
local arr = {1, 2, 3, 4, 5}
table.remove(arr)      -- remove last: {1, 2, 3, 4}
table.remove(arr, 2)   -- remove at index 2: {1, 3, 4}
```

### table.concat
```lua
local words = {"Hello", "World", "Lua"}
print(table.concat(words))          -- "HelloWorldLua"
print(table.concat(words, " "))     -- "Hello World Lua"
print(table.concat(words, ", "))    -- "Hello, World, Lua"

-- With range
local nums = {1, 2, 3, 4, 5}
print(table.concat(nums, "-", 2, 4))  -- "2-3-4"
```

### table.sort
```lua
local nums = {5, 2, 8, 1, 9}
table.sort(nums)
-- nums is now {1, 2, 5, 8, 9}

-- Custom comparator (descending)
table.sort(nums, function(a, b) return a > b end)
-- nums is now {9, 8, 5, 2, 1}

-- Sort strings
local words = {"charlie", "alice", "bob"}
table.sort(words)
-- words is now {"alice", "bob", "charlie"}
```

### table.unpack
```lua
local arr = {10, 20, 30}
local a, b, c = table.unpack(arr)
print(a, b, c)  -- 10  20  30

-- With range
local nums = {1, 2, 3, 4, 5}
local x, y = table.unpack(nums, 2, 3)
print(x, y)  -- 2  3
```

## Copying Tables

### Shallow Copy
```lua
local function shallow_copy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

local arr1 = {1, 2, 3}
local arr2 = shallow_copy(arr1)
```

### Deep Copy
```lua
local function deep_copy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deep_copy(value)
        else
            copy[key] = value
        end
    end
    return copy
end
```

## Table as Set

```lua
-- Use keys for set membership
local set = {
    apple = true,
    banana = true,
    cherry = true
}

-- Check membership
if set["apple"] then
    print("Set contains apple")
end

-- Add element
set["date"] = true

-- Remove element
set["banana"] = nil

-- Iterate set
for item in pairs(set) do
    print(item)
end
```

## Common Patterns for AOC

### Create 2D Grid
```lua
local function create_grid(rows, cols, default)
    local grid = {}
    for i = 1, rows do
        grid[i] = {}
        for j = 1, cols do
            grid[i][j] = default or 0
        end
    end
    return grid
end

local grid = create_grid(3, 3, ".")
```

### Convert String Array to 2D Character Grid
```lua
-- Common pattern for reading AOC input as a 2D character map
local function parse_grid(input)
    local map = {}

    -- Convert each string line to array of characters
    for i, line in ipairs(input) do
        map[i] = {}
        for j = 1, #line do
            map[i][j] = line:sub(j, j)
        end
    end

    return map
end

-- Example usage
local input = {
    "###.",
    "#..#",
    "####"
}

local map = parse_grid(input)

-- Get dimensions using # operator
local rows = #map          -- 3
local cols = #map[1]       -- 4

-- Access individual characters
print(map[1][1])  -- "#"
print(map[2][2])  -- "."

-- Modify characters
map[1][1] = "X"
```

### Create List of Tuples with Named Keys
```lua
-- Create tuples with named keys
local list = {}

-- Append tuples
table.insert(list, { x = 3, y = 7 })
table.insert(list, { x = 10, y = 20 })

-- Iterate with ipairs
for _, t in ipairs(list) do
    print(t.x, t.y)
end
-- Output:
-- 3    7
-- 10   20

-- Common AOC pattern: storing coordinates or structured data
local positions = {}
table.insert(positions, { row = 1, col = 5, value = "#" })
table.insert(positions, { row = 2, col = 3, value = "@" })

for _, pos in ipairs(positions) do
    print(string.format("(%d,%d) = %s", pos.row, pos.col, pos.value))
end
```

### Count Occurrences
```lua
local function count_occurrences(arr)
    local counts = {}
    for _, value in ipairs(arr) do
        counts[value] = (counts[value] or 0) + 1
    end
    return counts
end

local nums = {1, 2, 2, 3, 3, 3}
local counts = count_occurrences(nums)
print(counts[2])  -- 2
print(counts[3])  -- 3
```

### Find in Array
```lua
local function find(arr, value)
    for i, v in ipairs(arr) do
        if v == value then
            return i
        end
    end
    return nil
end

local colors = {"red", "green", "blue"}
print(find(colors, "green"))  -- 2
```

### Filter Array
```lua
local function filter(arr, predicate)
    local result = {}
    for _, value in ipairs(arr) do
        if predicate(value) then
            table.insert(result, value)
        end
    end
    return result
end

local nums = {1, 2, 3, 4, 5, 6}
local evens = filter(nums, function(n) return n % 2 == 0 end)
-- evens is {2, 4, 6}
```

### Map Array
```lua
local function map(arr, func)
    local result = {}
    for _, value in ipairs(arr) do
        table.insert(result, func(value))
    end
    return result
end

local nums = {1, 2, 3}
local doubled = map(nums, function(n) return n * 2 end)
-- doubled is {2, 4, 6}
```

### Reverse Array
```lua
local function reverse(arr)
    local result = {}
    for i = #arr, 1, -1 do
        table.insert(result, arr[i])
    end
    return result
end

local nums = {1, 2, 3, 4, 5}
local rev = reverse(nums)  -- {5, 4, 3, 2, 1}
```

## Table Equality

```lua
-- Tables are compared by reference, not content
local t1 = {1, 2, 3}
local t2 = {1, 2, 3}
print(t1 == t2)  -- false (different tables)

local t3 = t1
print(t1 == t3)  -- true (same reference)

-- Must compare contents manually
local function tables_equal(t1, t2)
    if #t1 ~= #t2 then return false end
    for i = 1, #t1 do
        if t1[i] ~= t2[i] then return false end
    end
    return true
end
```

## Tips

1. Tables are 1-indexed, not 0-indexed
2. Use `ipairs` for arrays, `pairs` for dictionaries
3. `#` operator only works on array part
4. `nil` removes a table entry
5. Tables are passed by reference
6. Use `table.insert` and `table.remove` for safe array modification

# Lua String Manipulation

## String Creation

```lua
local str1 = "double quotes"
local str2 = 'single quotes'
local multiline = [[
    Multiple lines
    preserved as-is
]]
local long_bracket = [=[
    Can use [[ inside ]]
    by using different bracket levels
]=]
```

## String Concatenation

```lua
local first = "Hello"
local last = "World"
local full = first .. " " .. last  -- "Hello World"

-- With numbers (automatic conversion)
local msg = "Count: " .. 42  -- "Count: 42"
```

## String Length

```lua
local str = "Hello"
print(#str)  -- 5

local empty = ""
print(#empty)  -- 0

-- Using # in loops to iterate through characters
local word = "XMAS"
for i = 1, #word do
    local char = word:sub(i, i)
    print(i, char)
end
-- Output:
-- 1    X
-- 2    M
-- 3    A
-- 4    S
```

**Tip:** The `#` operator is commonly used with `string.sub()` to convert strings to character arrays. See the "Convert String Array to 2D Character Grid" pattern in [tables.md](tables.md) for AOC examples.

## String Library Functions

### string.sub - Substring
```lua
local str = "Hello World"
print(string.sub(str, 1, 5))   -- "Hello"
print(string.sub(str, 7))      -- "World" (from 7 to end)
print(string.sub(str, -5))     -- "World" (last 5 chars)
print(string.sub(str, 1, -7))  -- "Hello" (from start, up to 7 from end)
```

### string.upper / string.lower
```lua
local str = "Hello World"
print(string.upper(str))  -- "HELLO WORLD"
print(string.lower(str))  -- "hello world"
```

### string.find - Search
```lua
local str = "Hello World"
local start, finish = string.find(str, "World")
print(start, finish)  -- 7, 11

-- Returns nil if not found
local pos = string.find(str, "xyz")
print(pos)  -- nil
```

### string.match - Pattern Matching
```lua
local str = "Price: $42.50"
local price = string.match(str, "%d+%.%d+")
print(price)  -- "42.50"

-- Extract number
local num = string.match("abc123def", "%d+")
print(num)  -- "123"
```

### string.gmatch - Iterate Matches
```lua
local str = "one two three"
for word in string.gmatch(str, "%w+") do
    print(word)
end
-- Output:
-- one
-- two
-- three

-- Split by comma
local csv = "apple,banana,cherry"
local fruits = {}
for fruit in string.gmatch(csv, "[^,]+") do
    table.insert(fruits, fruit)
end
```

### string.gsub - Replace
```lua
local str = "Hello World"
local result = string.gsub(str, "World", "Lua")
print(result)  -- "Hello Lua"

-- Replace multiple occurrences
local text = "foo bar foo"
local new_text = string.gsub(text, "foo", "baz")
print(new_text)  -- "baz bar baz"

-- Limit replacements
local limited = string.gsub("foo foo foo", "foo", "bar", 2)
print(limited)  -- "bar bar foo"
```

### string.format - Formatted Strings
```lua
local name = "Alice"
local age = 30
local msg = string.format("Name: %s, Age: %d", name, age)
print(msg)  -- "Name: Alice, Age: 30"

-- Number formatting
print(string.format("%.2f", 3.14159))  -- "3.14"
print(string.format("%05d", 42))       -- "00042"
print(string.format("%x", 255))        -- "ff" (hex)
```

### string.rep - Repeat
```lua
print(string.rep("*", 10))      -- "**********"
print(string.rep("ab", 3))      -- "ababab"
print(string.rep("x", 5, "-"))  -- "x-x-x-x-x"
```

### string.reverse - Reverse
```lua
local str = "Hello"
print(string.reverse(str))  -- "olleH"
```

### string.byte / string.char - Character Codes
```lua
-- Get ASCII/UTF-8 code
print(string.byte("A"))  -- 65
print(string.byte("ABC", 2))  -- 66 (second char)

-- Create string from codes
print(string.char(65, 66, 67))  -- "ABC"
```

## Pattern Matching Characters

Common patterns for string.match, string.gmatch, string.gsub, string.find:

```lua
-- Character classes
%a  -- letters
%d  -- digits
%w  -- alphanumeric
%s  -- whitespace
%p  -- punctuation
%c  -- control characters
%l  -- lowercase letters
%u  -- uppercase letters

-- Modifiers
*   -- 0 or more
+   -- 1 or more
-   -- 0 or more (non-greedy)
?   -- 0 or 1

-- Special
.   -- any character
[abc]   -- one of a, b, or c
[^abc]  -- not a, b, or c
%d%d%d  -- exactly 3 digits
```

### Pattern Examples
```lua
-- Extract email
local email = string.match("Contact: user@example.com", "[%w.]+@[%w.]+")
print(email)  -- "user@example.com"

-- Validate number
local num = "123"
if string.match(num, "^%d+$") then
    print("Valid number")
end

-- Split lines
local text = "line1\nline2\nline3"
for line in string.gmatch(text, "[^\n]+") do
    print(line)
end
```

## String Comparison

```lua
local a = "apple"
local b = "banana"

print(a == b)   -- false
print(a < b)    -- true (lexicographic order)
print(a ~= b)   -- true
```

## Escape Sequences

```lua
local str = "Line 1\nLine 2"     -- newline
local tab = "Col1\tCol2"          -- tab
local quote = "He said \"Hi\""    -- escaped quote
local backslash = "C:\\path"      -- backslash
```

## Tips for AOC

```lua
-- Read and split input by lines
local function split_lines(text)
    local lines = {}
    for line in string.gmatch(text, "[^\n]+") do
        table.insert(lines, line)
    end
    return lines
end

-- Split by delimiter
local function split(str, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    for token in string.gmatch(str, pattern) do
        table.insert(result, token)
    end
    return result
end

-- Trim whitespace
local function trim(s)
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

-- Parse numbers from string
local function extract_numbers(str)
    local numbers = {}
    for num in string.gmatch(str, "-?%d+") do
        table.insert(numbers, tonumber(num))
    end
    return numbers
end
```

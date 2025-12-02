# Lua Cheat Sheets for Advent of Code

Quick reference guides for Lua programming, focused on patterns commonly used in Advent of Code.

## Contents

1. **[Variables and Types](variables-and-types.md)** - Variables, data types, operators, scope
2. **[Strings](strings.md)** - String manipulation, pattern matching, common operations
3. **[Tables](tables.md)** - Arrays, dictionaries, nested structures, common patterns
4. **[File I/O](file-io.md)** - Reading and writing files, common AOC input patterns
5. **[Control Flow](control-flow.md)** - Conditionals, loops, functions

## Quick Examples

### Read Input File
```lua
local function read_input(filename)
    local lines = {}
    for line in io.lines(filename) do
        table.insert(lines, line)
    end
    return lines
end
```

### Parse Numbers
```lua
local function extract_numbers(str)
    local numbers = {}
    for num in string.gmatch(str, "-?%d+") do
        table.insert(numbers, tonumber(num))
    end
    return numbers
end
```

### 2D Grid
```lua
local grid = {}
for line in io.lines("input.txt") do
    local row = {}
    for char in line:gmatch(".") do
        table.insert(row, char)
    end
    table.insert(grid, row)
end
```

### Count Occurrences
```lua
local counts = {}
for _, value in ipairs(array) do
    counts[value] = (counts[value] or 0) + 1
end
```

## Resources

- [Official Lua Documentation](https://www.lua.org/manual/5.4/)
- [Learn Lua in Y Minutes](https://learnxinyminutes.com/docs/lua/)
- [Programming in Lua](https://www.lua.org/pil/)
- [NvChad Lua Guide](https://nvchad.com/docs/quickstart/learn-lua)

## Tips for AOC with Lua

1. **1-indexed**: Lua arrays start at 1, not 0
2. **Tables everywhere**: Use tables for arrays, dicts, sets, objects
3. **Pattern matching**: Learn Lua patterns (similar to regex but different)
4. **ipairs vs pairs**: Use `ipairs` for arrays, `pairs` for dictionaries
5. **No ++ operator**: Use `i = i + 1` instead of `i++`
6. **String immutability**: Strings are immutable, concatenation creates new strings
7. **Local variables**: Always use `local` to avoid global pollution
8. **tonumber()**: Convert strings to numbers explicitly
9. **math library**: Use `math.floor()`, `math.ceil()`, `math.abs()`, etc.
10. **No continue**: Lua doesn't have `continue`, use `goto` or restructure logic

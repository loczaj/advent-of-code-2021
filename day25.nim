import strutils, sequtils
import aoctools

var 
  map = readFile("input25.txt").splitLines()
  stepCount = 1

proc moduloX(x: int): int = 
  x mod map[0].len

proc moduloY(y: int): int = 
  y mod map.len

proc step(): bool =
  for y in 0 ..< map.len:
    var x = 0
    while x < map[0].len:
      if map[x, y] == '>' and map[moduloX(x+1), y] == '.':
        map[x, y] = '#'
        map[moduloX(x+1), y] = '>'
        result = true
        inc x
      inc x

  map.applyIt it.replace("#", ".")

  for x in 0 ..< map[0].len:
    var y = 0
    while y < map.len:
      if map[x, y] == 'v' and map[x, moduloY(y+1)] == '.':
        map[x, y] = '#'
        map[x, moduloY(y+1)] = 'v'
        result = true
        inc y
      inc y

  map.applyIt it.replace("#", ".")

while step():
  inc stepCount

echo stepCount
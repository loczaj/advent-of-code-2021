import strutils, std/strscans, sets
import aoctools

let input = readFile("input13.txt").splitLines()
var dots: seq[tuple[x, y: int]]

for li, line in input[0 .. 790]:
  let (s, x, y) = line.scanTuple("$i,$i")
  assert s

  dots.add((x, y))

proc foldx(linex: int): void =
  for dot in mitems(dots):
    if dot.x > linex:
      dot.x = linex - (dot.x - linex)
  
proc foldy(liney: int): void =
  for dot in mitems(dots):
    if dot.y > liney:
      dot.y = liney - (dot.y - liney)


foldx(655)

var dotset: HashSet[tuple[x, y: int]]
for dot in dots:
  dotset.incl(dot)
echo dotset.len

foldy(447)
foldx(327)
foldy(223)  
foldx(163)
foldy(111)
foldx(81)
foldy(55)
foldx(40)
foldy(27)
foldy(13)
foldy(6)

var map: Map[40, 8, char]
map.fill(' ')

for dot in dots:
  map[dot.x, dot.y] = '#'

echo map.toStr("")

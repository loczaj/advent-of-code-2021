import strutils, sequtils, algorithm, sets

type Point = tuple[x:int, y:int, height:int]
const directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]

let input = readFile("input09.txt").splitLines()

proc height(x, y: int): int =
  parseInt($(input[y][x]))

proc checkDeepest(x, y: int): int =
  let height = height(x, y)
  let neighbours = directions.mapIt (x: it[0] + x, y: it[1] + y)
  for neig in neighbours:
    if neig.x >= 0 and neig.y >= 0 and neig.x < 100 and neig.y < 100:
      if height(neig.x, neig.y) <= height:
        return -1 
  return height

var
  sum = 0
  lowpoints: seq[Point]
  basins: seq[HashSet[Point]]

for x in 0 ..< 100:
  for y in 0 ..< 100:
    let height = checkDeepest(x, y)
    if height > -1:
      sum += height + 1
      lowpoints.add (x, y, height)

echo sum

proc addToBasin(basin: var HashSet[Point], point: Point): void =
  if basin.contains(point) or point.height == 9: return
  basin.incl(point)

  let neighbours = directions.mapIt (x: it[0] + point.x, y: it[1] + point.y)
  for neig in neighbours:
    if neig.x < 0 or neig.y < 0 or neig.x > 99 or neig.y > 99:
      continue
  
    let next = (neig.x, neig.y, height(neig.x, neig.y))
    addToBasin(basin, next)

for li, lowpoint in lowpoints:
  var basin: HashSet[Point] 
  addToBasin(basin, lowpoint)
  basins.add(basin)
  
let sizes = basins.mapIt(it.len).sorted()
echo sizes[^3] * sizes[^2] * sizes[^1]

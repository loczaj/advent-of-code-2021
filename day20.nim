import strutils, sequtils
import aoctools

let input = readFile("input20.txt").splitLines()
let enhancer = input[0]
var image = input[2..^1]
var field = '.'

proc index(numimage: string): int =
  numimage.mapIt(if it=='#': '1' else: '0').join.parseBinInt

proc backindex(): int =
  var row = field & field & field
  index(row & row & row)

proc index(x, y: int): int =
  var upper = image[x-1, y-1, field] & image[x, y-1, field] & image[x+1, y-1, field]
  var middl = image[x-1,   y, field] & image[x,   y, field] & image[x+1,   y, field]
  var lower = image[x-1, y+1, field] & image[x, y+1, field] & image[x+1, y+1, field]

  index(upper & middl & lower)

proc emptyLine(size: int): string =
  for _ in 1..size:
    result &= field

proc enhance(): void =
  let newsize = image.len + 2
  image.insert(emptyLine(newsize), 0)
  image.insert(emptyLine(newsize), newsize-1)

  for y in 1..newsize-2:
    image[y].insert($field, 0)
    image[y].insert($field, newsize-1)

  var replaces: seq[tuple[x, y: int, v: char]]
  forArea(0,0, newsize-1, newsize-1):
    replaces.add((x, y, enhancer[index(x, y)]))
    
  for r in replaces:
    image[r.x, r.y] = r.v

  field = enhancer[backindex()]

proc countLit(): int =
  forArea(0, 0, image.len-1, image.len-1):
    if image[x, y] == '#': inc result

for i in 1..50:
  enhance()

echo countLit()

import strutils, sequtils
import aoctools

var map: Map[10, 10, int]
let input = readFile("input11.txt").splitLines()

for li, line in input:
  for ci, ch in line:
    map[li][ci] = parseInt($ch)

proc flash(x, y: int): int =
  if map[x, y] > 9:
    map[x, y] = -10
    inc result
  
    for n in neighbours8(map, x, y):
      inc map[n.x, n.y]

proc eval(): int =
  forMap map:
    inc map[x, y]

  var flashes0 = -1
  while result > flashes0:
    flashes0 = result
    forMap map:
      result += flash(x, y)

  forMap map:
    if map[x, y] < 0:
      map[x, y] = 0

var step, flashes = 0
while true:
  inc step
  var plus = eval()
  flashes += plus

  if step == 100: echo flashes
  if plus == 100:
    echo step
    break

import strutils, sequtils, std/strscans, sugar
import aoctools

let input = readFile("input05.txt").splitLines().mapIt it.scanTuple("$i,$i -> $i,$i")
var map: Map[1000, 1000, int]

let xlines = input.filterIt (it[1] == it[3])
let ylines = input.filterIt (it[2] == it[4])

for (_, x0, y0, x1, y1) in xlines:
  for y in min(y0, y1) .. max(y0, y1):
    inc map[x0, y]

for (_, x0, y0, x1, y1) in ylines:
  for x in min(x0, x1) .. max(x0, x1):
    inc map[x, y0]

echo map.count cell => cell > 1

let downlines = input.filterIt (it[1] < it[3] and it[2] < it[4]) or (it[1] > it[3] and it[2] > it[4])
let uplines = input.filterIt (it[1] < it[3] and it[2] > it[4]) or (it[1] > it[3] and it[2] < it[4])

for (_, x0, y0, x1, y1) in downlines:
  let y0 = min(y0, y1)
  for x in min(x0, x1) .. max(x0, x1):
    inc map[x, y0 + x - min(x0, x1)]

for (_, x0, y0, x1, y1) in uplines:
  let y0 = max(y0, y1)
  for x in min(x0, x1) .. max(x0, x1):
    inc map[x, y0 - x + min(x0, x1)]

echo map.count cell => cell > 1

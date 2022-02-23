import strutils, sequtils, std/strscans, algorithm, math, sets, tables, sugar
import aoctools, dijkstra

var map: Map[500, 500, int]
var connections: seq[tuple[src, dst: string; cost: int]]
var cost = 0

for y, line in readFile("input15.txt").splitLines().toSeq:
  for x, ch in line:
    map[x, y] = parseInt($ch)

for i in 0..4:
  for j in 0..4:
    if i == 0 and j == 0: continue
    let xoffset = i*100
    let yoffset = j*100
    forArea(0,0, 99,99):
      map[x + xoffset, y + yoffset] = ((map[x, y] + i + j - 1) mod 9) + 1
      
# echo map.toStr("")

for (x0, y0) in points map:
  let orig = $x0 & ":" & $y0 
  for (x, y) in neighbours4(map, x0, y0):
    let neig = $x & ":" & $y
    connections.add((orig, neig, map[x, y]))

let graph = initGraph(connections)
let path = graph.dijkstraPath("0:0", "499:499")

for cell in path[1 .. ^1]:
  let(s, x, y) = cell.scanTuple("$i:$i")
  cost += map[x, y]

echo cost


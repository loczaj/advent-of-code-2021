import aoctools, btree, tables

var tree = initBTree[int, char]()

tree.add(10, 'e')
tree.add(30, 'h')
tree.add(0, '0')
tree.add(20, '2')

tree.add(12, 'e')

echo tree.toStr()


var ta: CountTable[string]
ta["hello"] = 3

echo ta



import strutils, sequtils, std/strscans, algorithm, math, sets, tables, sugar
import aoctools, dijkstra

var map: Map[10, 10, int]
var connections: seq[tuple[src, dst: string; cost: int]]
var cost = 0

for y, line in readFile("input15.exa").splitLines().toSeq:
  for x, ch in line:
    map[x, y] = parseInt($ch)

for (x0, y0) in points map:
  let orig = $x0 & ":" & $y0 
  for (x, y) in neighbours4(map, x0, y0):
    let neig = $x & ":" & $y
    connections.add((orig, neig, map[x, y]))

let graph = initGraph(connections)
let path = graph.dijkstraPath("0:0", "9:9")

for cell in path[1 .. ^1]:
  let(s, x, y) = cell.scanTuple("$i:$i")
  cost += map[x, y]

echo cost


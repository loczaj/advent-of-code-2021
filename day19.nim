import strutils, sequtils, std/strscans, sets, tables, std/re
import aoctools

type Point = tuple[x, y, z: int]
type Rotation = seq[string]
type Scanner = seq[Point]

let rotations = readFile("rotations.txt").grid
let input = readFile("input19.txt").splitLines()

var scanners: seq[Scanner]
var scannerRead: Scanner

for line in input:
  if line =~ re"--- scanner \d+ ---":
    scannerRead = @[]
    continue
  let (succ, x, y, z) = line.scanTuple("$i,$i,$i")
  if succ:
    scannerRead.add((x, y, z))
  else:
    scanners.add scannerRead

proc getCoord(p: Point, coord: string): int =
  case coord:
  of "xp": return p.x
  of "xn": return -p.x
  of "yp": return p.y
  of "yn": return -p.y
  of "zp": return p.z
  of "zn": return -p.z
  else: assert false

proc rotate(p: Point, rot: Rotation): Point =
  result.x = getCoord(p, rot[0])
  result.y = getCoord(p, rot[1])
  result.z = getCoord(p, rot[2])

proc `-`(a, b: Point): Point =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z

proc `+`(a, b: Point): Point =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z

proc `*`(a, b: Point): int =
  result += abs(a.x - b.x)
  result += abs(a.y - b.y)
  result += abs(a.z - b.z)

proc match(sa, sb: Scanner): tuple[matches: bool, rot: Rotation, shift: Point] =
  for rot in rotations:
    let rotatedb = sb.mapIt(rotate(it, rot))
    
    var differences: CountTable[Point]
    for pointa in sa:
      for pointb in rotatedb:
        differences.inc(pointa - pointb)

    for (diff, count) in differences.pairs:
      if count >= 12:
        return (true, rot, diff)

var visited: HashSet[int]
proc findConnected(base: int, task: int): seq[Point] =
  visited.incl(base)
  for target in 0 ..< scanners.len:
    if visited.contains(target): continue
    let(matches, rot, shift) = match(scanners[base], scanners[target])
    if matches:
      let points = findConnected(target, task)
      result.add(points.mapIt(rotate(it, rot)).mapIt(it + shift))
  if task == 1: result.add(scanners[base])
  else: result.add((0, 0, 0))

let points1 = findConnected(0, 1)
echo points1.deduplicate.len

visited.clear()
let points2 = findConnected(0, 2)
var distances: seq[int]
for i in 0 .. points2.len-1:
  for j in i+1 .. points2.len-1:
    distances.add(points2[i] * points2[j])
echo distances.max

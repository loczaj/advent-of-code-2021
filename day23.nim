import strutils, sequtils, std/strscans, sets, tables, std/re
import aoctools

type Cuboid = tuple[x0, x1, y0, y1, z0, z1: int]
var commands: seq[tuple[p: Cuboid, a: bool]]
var reactor: seq[Cuboid]

let input = readFile("input22.txt").splitLines()
for line in input:
  let(s, x0, x1, y0, y1, z0, z1) = line.scanTuple("on x=$i..$i,y=$i..$i,z=$i..$i")
  if s: 
    commands.add(((x0, x1, y0, y1, z0, z1), true))
  else:
    let(s, x0, x1, y0, y1, z0, z1) = line.scanTuple("off x=$i..$i,y=$i..$i,z=$i..$i")
    if s: commands.add(((x0, x1, y0, y1, z0, z1), false))
    else: assert false

# echo commands
proc volume(c: Cuboid): int =
  (c.x1 - c.x0 + 1) * (c.y1 - c.y0 + 1) * (c.z1 - c.z0 + 1)

proc intersecting(a, b: Cuboid): bool =
  if a.x1 < b.x0 or b.x1 < a.x0: return false
  if a.y1 < b.y0 or b.y1 < a.y0: return false
  if a.z1 < b.z0 or b.z1 < a.z0: return false
  return true

proc intersect(a, b: Cuboid): Cuboid =
  result.x0 = max(a.x0, b.x0)
  result.x1 = min(a.x1, b.x1)
  result.y0 = max(a.y0, b.y0)
  result.y1 = min(a.y1, b.y1)
  result.z0 = max(a.z0, b.z0)
  result.z1 = min(a.z1, b.z1)

proc minus(a, b: Cuboid): seq[Cuboid] = 
  if not intersecting(a, b): return @[a]
  let s = intersect(a, b)
  if a.x0 < s.x0:
    result.add((a.x0, s.x0-1, a.y0, a.y1, a.z0, a.z1))
  if s.x1 < a.x1:
    result.add((s.x1+1, a.x1, a.y0, a.y1, a.z0, a.z1))
  if a.y0 < s.y0:
    result.add((s.x0, s.x1, a.y0, s.y0-1, s.z0, s.z1))
  if s.y1 < a.y1:
    result.add((s.x0, s.x1, s.y1+1, a.y1, s.z0, s.z1))
  if a.z0 < s.z0:
    result.add((s.x0, s.x1, a.y0, a.y1, a.z0, s.z0-1)) 
  if s.z1 < a.z1:
    result.add((s.x0, s.x1, a.y0, a.y1, s.z1+1, a.z1))

for (cuboid, on) in commands:
  #var nextreactor: seq[Cuboid]
  let len = reactor.len
  for i in 1..len:
    reactor.add(minus(reactor[0], cuboid))
    reactor.delete(0)

  if on: reactor.add(cuboid)

echo reactor.map(volume).foldl(a+b)

# for cu in reactor:
#   let (x0, x1, y0, y1, z0, z1) = cu
#   echo x0, "..", x1, " ", y0, "..", y1, " ", z0, "..", z1, "\n"

import strutils, sequtils, sugar, std/re, options

const directions4* = [(1, 0), (-1, 0), (0, 1), (0, -1)]
const directions8* = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, 1), (-1, -1), (1, -1)]

### Map ###

type
  Map*[W, H: static[int], T] =
    array[0..H-1, array[0..W-1, T]]

proc `[]`*[W, H, T](map: Map[W, H, T]; x, y: int): T =
  # assert (x >= 0 and y >= 0 and x < H and y < W)
  return map[y][x]

proc `[]`*[W, H, T](map: var Map[W, H, T]; x, y: int): var T =
  # assert (x >= 0 and y >= 0 and x < H and y < W)
  return map[y][x]

proc `[]=`*[W, H, T](map: var Map[W, H, T]; x, y: int; value: T): void  =
  # assert (x >= 0 and y >= 0 and x <= H and y < W)
  map[y][x] = value

template forArea*(x0, y0, x1, y1: int, body: untyped) =
  for y {.inject.} in y0 .. y1:
    for x {.inject.} in x0 .. x1:
      body

template forMap*[W, H, T](map: Map[W, H, T], body: untyped) =
  forArea(0, 0, W-1, H-1):
    body

iterator points*[W, H, T](map: Map[W, H, T]): tuple[x, y: int] =
  forMap map:
    yield (x, y)

iterator neighbours4*[W, H, T](map: Map[W, H, T], x, y: int): tuple[x, y: int] =
  for neigb in directions4.mapIt (x: it[0] + x, y: it[1] + y):
    if neigb.x >= 0 and neigb.y >= 0 and neigb.x < H and neigb.y < W:
      yield neigb

iterator neighbours8*[W, H, T](map: Map[W, H, T], x0, y0: int): tuple[x, y: int] =
  for neigb in directions8.mapIt (x: it[0] + x0, y: it[1] + y0):
    if neigb.x >= 0 and neigb.y >= 0 and neigb.x < H and neigb.y < W:
      yield neigb

proc fill*[W, H, T](map: var Map[W, H, T], value: T): void =
  forMap map:
    map[x, y] = value

proc count*[W, H, T](map: Map[W, H, T], predicate: proc(cell: T): bool): int =
  for row in map:
    result += row.toSeq.countIt predicate(it)

proc `+`*[W, H, T](a, b: sink Map[W, H, T]): Map[W, H, T] =
  forMap result:
    result[x, y] = a[x, y] + b[x, y]

proc toStr*(map: Map, sep:string = " "): string =
  for row in map:
    for value in row:
      result &= $value & sep
    result &= "\n"

proc grid*(data:string, sep:string = ""): seq[seq[string]]

proc initFromGrid*[W, H, T](data: string, parser: string -> T, sep:string = ""): Map[W, H, T] =
  let grid = grid(data, sep)
  assert high(grid) + 1 == H
  for row in countup(0, H - 1):
    assert high(grid[row]) + 1 == W
    for col in countup(0, W - 1):
      result[row][col] = parser(grid[row][col])

### seq[seq[...]] ###

proc grid*(data:string, sep:string = ""): seq[seq[string]] =
    if sep == "":
        return data.splitLines.mapIt(it.splitWhitespace)
    return data.splitLines.mapIt(it.split(sep))

proc ints*(data:string): seq[int] =
    data.findAll(re"-?\d+").map(parseInt)

proc intgrid*(data:string): seq[seq[int]] =
    data.splitLines.map(ints)

proc `[]`*(image: seq[string]; x,y: int): char =
  return image[y][x]

proc `[]`*(image: seq[string]; x,y: int, default: char): char =
  if x < 0 or y < 0 or x >= image.len or y >= image.len:
    return default
  else:
    return image[y][x]

proc `[]`*(image: var seq[string]; x,y: int): var char =
  return image[y][x]

proc `[]=`*(image: var seq[string]; x,y: int; value: char): void  =
  image[y][x] = value

proc toStr*(source: seq[string]): string =
  for line in source:
    result &= line & '\n'

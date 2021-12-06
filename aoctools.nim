import strutils, sequtils, std/re

type
  Map*[W, H: static[int], T] =
    array[0..W-1, array[0..H-1, T]]

template forArea*(x0, y0, x1, y1: int, body: untyped) =
  for x {.inject.} in x0 .. x1:
    for y {.inject.} in y0 .. y1:
      body

template forMap*(map: Map, body: untyped) =
  forArea(0, 0, high(map), high(map[0])):
    body

proc count*[W, H, T](map: Map[W, H, T], predicate: proc(cell: T): bool): int =
  for row in map:
    result += row.toSeq.countIt predicate(it)

proc `+`*[W, H, T](a, b: Map[W, H, T]): Map[W, H, T] =
  forMap a:
    result[x][y] = a[x][y] + b[x][y]

type Dot* = object
  x, y: int

proc grid*(data:string, sep:string = ""): seq[seq[string]] =
    if sep == "":
        return data.splitLines.mapIt(it.splitWhitespace)
    return data.splitLines.mapIt(it.split(sep))

proc ints*(data:string): seq[int] =
    data.findAll(re"-?\d+").map(parseInt)

proc intgrid*(data:string): seq[seq[int]] =
    data.splitLines.map(ints)

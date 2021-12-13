import strutils, sequtils, tables

let input = readFile("input12.txt").splitLines()
var conns: Table[string, seq[string]]
var paths: seq[string]

for (caveA, caveB) in input.mapIt(it.split "-").mapIt((it[0], it[1])):
  conns.mgetOrPut(caveA, @[]).add(caveB)
  conns.mgetOrPut(caveB, @[]).add(caveA)

proc visit(cave: string, path: string, singleBound: sink bool): void =
  
  if cave[0].isLowerAscii:
    case path.count(cave):
      of 2:
        return
      of 1:
        if cave == "start" or singleBound:
          return
        else:
          singleBound = true
      else:
        discard

  let path = path & cave

  if cave == "end":
    if not paths.contains(path):
      paths.add(path)
  else:
    for connected in conns[cave]:
      visit(connected, path, singleBound)


visit("start", "", true)
echo paths.len

paths = @[]
visit("start", "", false)
echo paths.len

import strutils, sequtils, std/strscans

type
  Map[W, H: static[int], T] =
    array[0..W-1, array[0..H-1, T]]

template forMap(m: Map, body: untyped) =
  for x {.inject.} in 0 .. high m:
    for y {.inject.} in 0 .. high m[0]:
      body

type Board = object
  map: Map[5, 5, int]
  mark: Map[5, 5, bool]
  mx, my: array[5, int]

let input = readFile("input04.txt").splitLines()
let bingoNumbers = input[0].split(",").map(parseInt)

var boards: array[100, Board]
var wins = 0

for i in 0 .. 99:
  for l in 0 .. 4:
    let (success, a, b, c, d, e) = scanTuple(input[6*i + l + 2], "$s$i$s$i$s$i$s$i$s$i")
    assert success
    boards[i].map[l] = [a, b, c, d, e]

proc mark(board: var Board, xp, yp: int): int =
  board.mark[xp][yp] = true
  inc board.mx[xp]
  inc board.my[yp]

  if board.mx[xp] == 5 or board.my[yp] == 5:
    forMap board.map:
      if not board.mark[x][y]:
        result += board.map[x][y]
      board.map[x][y] = -1

for number in bingoNumbers:
  for b in 0 .. 99:
    forMap boards[b].map:

      if boards[b].map[x][y] == number:
        let product = mark(boards[b], x, y)
        if product > 0:
          inc wins
          if wins == 1 or wins > 99:
            echo product * number

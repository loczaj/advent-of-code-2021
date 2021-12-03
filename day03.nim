import strutils, sequtils
from sugar import `=>`

proc calculateBitCounts(report: seq[string]): array[12, int] =
  for line in report:
    for i, bit in line:
      if bit == '0': dec result[i]
      if bit == '1': inc result[i]

let
  input = readFile("input03.txt").splitLines()
  bitCounter = calculateBitCounts(input)
  gamma = bitCounter.mapIt(if it > 0: '1' else: '0').join.parseBinInt
  epsilon = bitCounter.mapIt(if it < 0: '1' else: '0').join.parseBinInt

echo gamma * epsilon

proc filterReport(report: sink seq[string], predicate: proc(n: int): bool): string =
  for i in 0 .. 11:
    if predicate calculateBitCounts(report)[i]:
      report = report.filter s => s[i] == '1'
    else:
      report = report.filter s => s[i] == '0'

    if report.len == 1: return report[0]
  assert false

let
  oxygen = parseBinInt input.filterReport n => n >= 0
  co2 = parseBinInt input.filterReport n => n < 0

echo oxygen * co2

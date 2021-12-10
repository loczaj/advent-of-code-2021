import strutils, sequtils, math, stats, algorithm

let input = readFile("input07.txt").splitLines()[0].split(",").map parseInt

var
  fuel1, fuel2l, fuel2h: int 
  statistics: RunningStat

statistics.push(input)

let
  median = input.sorted()[input.len div 2]
  meanLow = statistics.mean().int
  meanHigh = statistics.mean().int + 1

for position in input:
  fuel1 += abs(position - median)
  fuel2l += (abs(position - meanLow) + (position - meanLow) ^ 2) div 2
  fuel2h += (abs(position - meanHigh) + (position - meanHigh) ^ 2) div 2

echo fuel1
echo min(fuel2l, fuel2h)

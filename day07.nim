import strutils, sequtils, math, stats, algorithm

let input = readFile("input07.txt").splitLines()[0].split(",").map parseInt

var
  fuel1, fuel2, fuel3: int 
  statistics: RunningStat

statistics.push(input)

let
  pos1 = input.sorted()[input.len div 2]
  pos2 = statistics.mean().int
  pos3 = statistics.mean().int + 1

for position in input:
  let dist1 = abs(position - pos1) 
  let dist2 = abs(position - pos2) 
  let dist3 = abs(position - pos3) 
  fuel1 += dist1
  fuel2 += (dist2 + dist2 ^ 2) div 2
  fuel3 += (dist3 + dist3 ^ 2) div 2

echo fuel1
echo min(fuel2, fuel3)

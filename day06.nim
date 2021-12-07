import sequtils, strutils, std/tables

let input = readFile("input06.txt").splitLines()[0].split(",").map parseInt
var fishes = input.toCountTable()

for day in 1 .. 256:
  
  let born = fishes[0]
  for age in 0 .. 7:
    fishes[age] = fishes[age+1]
  
  fishes[6] = fishes[6] + born
  fishes[8] = born

  if day == 80 or day == 256:
    echo fishes.values().toSeq().foldl(a+b)

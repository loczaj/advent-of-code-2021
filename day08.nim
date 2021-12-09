import strutils, sequtils, std/strscans, algorithm, math

const digits = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]

proc decodeDigit(mapping, pattern: string): int = 
  for di, digit in digits:
    if pattern.mapIt("abcdefg"[mapping.find(it)]).sorted == digit:
      return di
  return -1 

proc isValidMapping(mapping: string, patterns: array[14, string]): bool =
  for pattern in patterns:
    if decodeDigit(mapping, pattern) < 0:
      return false
  return true

var sum = 0
var fig1478 = 0
let input = readFile("input08.txt").splitLines()

for line in input:
  let(s, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, o1, o2, o3, o4) = line.scanTuple("$w $w $w $w $w $w $w $w $w $w | $w $w $w $w")
  assert s

  for o in [o1, o2, o3, o4]:
    if o.len in [2, 3, 4, 7]: inc fig1478

  var mapping = "abcdefg"
  while mapping.nextPermutation():
    if isValidMapping(mapping, [i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, o1, o2, o3, o4]):
      for oi, o in [o4, o3, o2, o1]:
        sum += decodeDigit(mapping, o) * 10 ^ oi
      break

echo fig1478
echo sum

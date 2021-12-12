import strutils, algorithm, re

var input = readFile("input10.txt").splitLines()
var
  error = 0
  lineScores: seq[int]

for line in mitems(input):
  while line.find(re"\(\)|\[\]|\{\}|<>") > -1:
    line = line.multiReplace(("()", ""), ("[]", ""), ("{}", ""), ("<>", ""))

  var corrupted = false
  for ch in line:
    case ch:
      of ')':
        error += 3
        corrupted = true
        break
      of ']':
        error += 57
        corrupted = true
        break
      of '}':
        error += 1197
        corrupted = true
        break
      of '>':
        error += 25137
        corrupted = true
        break
      else:
        discard
  
  if not corrupted:
    var score = 0
    for ch in line.reversed:
      case ch:
        of '(':
          score *= 5
          score += 1
        of '[':
          score *= 5
          score += 2
        of '{':
          score *= 5
          score += 3
        of '<':
          score *= 5
          score += 4
        else:
          assert false
    
    lineScores.add(score)

echo error 
echo lineScores.sorted[lineScores.len div 2]

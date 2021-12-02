import strutils, sequtils
from sugar import `=>`

let input = readFile("input02.txt").splitLines().map s => (s[0], parseInt $s[^1])
var distance, depth, aim = 0

for (command, x) in input:
  case command:
    of 'd': aim += x
    of 'u': aim -= x
    else:
      distance += x
      depth += aim * x

echo distance * aim
echo distance * depth

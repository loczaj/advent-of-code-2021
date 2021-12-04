import strutils, sequtils

let input = readFile("input02.txt").splitLines().mapIt (it[0], parseInt $it[^1])
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

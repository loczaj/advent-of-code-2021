import strutils, sequtils

let input = readFile("./input01.txt").splitLines.map(parseInt)

echo (0 ..< input.len - 1).toSeq.countIt(input[it] < input[it+1])
echo (0 ..< input.len - 3).toSeq.countIt(input[it] < input[it+3])

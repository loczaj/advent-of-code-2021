import strutils, sequtils

let input = readFile("input01.txt").splitLines.map(parseInt)

echo toSeq(0 .. input.len - 2).countIt input[it] < input[it+1]
echo toSeq(0 .. input.len - 4).countIt input[it] < input[it+3]

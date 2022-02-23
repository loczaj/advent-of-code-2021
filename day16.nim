import strutils, sequtils, std/strscans, algorithm, math, sets, tables, sugar
import aoctools, dijkstra

let input = readFile("input16.txt")
#let input = "04005AC33890"

var binary: string
var versionSum = 0

for ch in input:
  binary.add toBin(parseHexInt($ch), 4)
  #binary.add " "
echo binary

proc toOctet(pos: int): int =
  if pos mod 8 == 0: return pos
  else: return pos + (8 - (pos mod 8))

proc parseLiteral(pos: var int): int =
  echo "literal at ", pos
  var keepReading = true
  var image: string
  while keepReading:
    let pentet = binary[pos .. pos+4]
    if pentet[0] == '0': keepReading = false
    image.add(pentet[1..4])
    pos += 5
  
  result = parseBinInt image
  echo "    val= ", result

proc parsePacket(pos: var int, sub: bool = false): int

proc parseOperator(pos: var int, typeid: int): int =
  echo "operator at ", pos, " type= ", typeid
  let lengthType = binary[pos]
  pos += 1
  
  var packets: seq[int]

  if lengthType == '0':
    let bitlength = binary[pos .. pos+14].parseBinInt
    echo "    number of bits ", bitlength
    pos += 15
    let endpos = pos + bitlength
    while endpos > pos:
      echo "   op packet at ", pos
      packets.add parsePacket(pos, sub=true)

  else:
    let numberlength = binary[pos .. pos+10].parseBinInt
    pos += 11
    echo "    number of args ", numberlength
    for _ in 1 .. numberlength:
      echo "   op argument at ", pos
      packets.add parsePacket(pos, sub=true)

  case typeid:
  of 0:
    result = packets.sum()
  of 1:
    result = 1
    for p in packets: result *= p
  of 2:
    result = packets[0]
    for p in packets: result = min(result, p)
  of 3:
    result = packets[0]
    for p in packets: result = max(result, p)
  of 5:
    if packets[0] > packets[1]: result = 1
    else: result = 0
  of 6:
    if packets[0] < packets[1]: result = 1
    else: result = 0
  of 7:
    if packets[0] == packets[1]: result = 1
    else: result = 0
  else:
    assert false

proc parsePacket(pos: var int, sub: bool = false): int =
  let version = binary[pos .. pos+2].parseBinInt
  let typeid = binary[pos+3 .. pos+5].parseBinInt
  pos += 6

  versionSum += version
  
  if typeid == 4:
    result = parseLiteral(pos)
  else:
    result = parseOperator(pos, typeid)
  
  if not sub: pos = pos.toOctet

var pos = 0

echo parsePacket(pos)

#echo versionSum

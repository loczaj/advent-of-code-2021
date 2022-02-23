import strutils, sequtils, std/strscans, algorithm, math, sets, tables, sugar
import aoctools

type
  Pair {.acyclic.} = ref object
    lnum, rnum: int
    lpair, rpair: Pair

proc pair(l, r: int): Pair =
  result = new Pair
  result.lnum = l
  result.rnum = r

proc pair(l, r: Pair): Pair =
  result = new Pair
  result.lnum = -1
  result.rnum = -1
  result.lpair = l
  result.rpair = r    

proc pair(l: int, r: Pair): Pair =
  result = new Pair
  result.lnum = l
  result.rnum = -1
  result.rpair = r

proc pair(l: Pair, r: int): Pair =
  result = new Pair
  result.lnum = -1
  result.rnum = r
  result.lpair = l

proc str(p: Pair): string =
  result = "["
  if p.lnum > -1: result &= $(p.lnum)
  else: result &= str(p.lpair)
  result &= ","
  if p.rnum > -1: result &= $(p.rnum)
  else: result &= str(p.rpair)
  result &= "]"

proc parseNum(str: string): int =
  var endp = 0
  for i in 0..len(str) - 1:
    if str[i] in "0123456789":
      endp = i
    else: 
      break
  # echo str[0..endp]
  result = parseInt(str[0..endp])

proc parseNumRev(str: string): int =
  var startp = len(str)-1
  for i in countdown(len(str)-1, 0):
    if str[i] in "0123456789":
      startp = i
    else: 
      break
  #echo str[startp..^1]
  result = parseInt(str[startp..^1])


proc parse(input: string, pos: var int): Pair =
  #echo input
  result = new Pair
  assert input[pos] == '['
  inc pos
  if input[pos] in "0123456789":
    #result.lnum = parseInt($input[pos])
    result.lnum = parseNum(input[pos..^1])
    pos += ($result.lnum).len
  else:
    result.lnum = -1
    result.lpair = parse(input, pos)
  assert input[pos] == ','
  inc pos
  if input[pos] in "0123456789":
    result.rnum = parseNum(input[pos..^1])
    pos += ($result.rnum).len
  else:
    result.rnum = -1
    result.rpair = parse(input, pos)
  assert input[pos] == ']'
  inc pos

proc parse(input: string): Pair =
  var pos = 0
  return parse(input, pos)

####################################
proc add(l, r: Pair): Pair =
  result = new Pair
  result.lnum = -1
  result.rnum = -1
  result.lpair = l
  result.rpair = r


proc explode(p: var Pair, level: int): bool =
  #echo p.str
  if level >= 4:
    #echo "level >= 4"
    if p.lnum > -1 and p.rnum > -1:
      #echo "++"
      p.lnum = 1000000 + p.lnum
      p.rnum = 1000000 + p.rnum
      return true
    elif p.lnum < 0 and p.rnum < 0:
      if explode(p.lpair, level+1):
        return true
      else:
        return explode(p.lpair, level+1)
    else:
      if p.lnum < 0:
        return explode(p.lpair, level+1)
      else:
        return explode(p.rpair, level+1)
  else:
    if p.lnum < 0:
      if explode(p.lpair, level+1):
        return true
    if p.rnum < 0:
      return explode(p.rpair, level+1)
    return false

proc explode2(ip: Pair): Pair =
  var str = ip.str()
  let lnums = str.find("1000")
  let lnume = str.find(",", lnums) - 1
  let rnums = lnume + 2
  let rnume = str.find("]", rnums) - 1

  let lnum = parseInt(str[lnums .. lnume])
  let rnum = parseInt(str[rnums .. rnume])

  #echo str[lnums..lnume]
  #echo str[rnums..rnume]

  for i in rnume+1 .. str.len-1:
    if str[i] in "0123456789":
      let num = parseNum(str[i..^1])
      str.delete(i, i + ($(num)).len - 1)
      str.insert($(rnum+num-1000000), i)
      break
  
  var offset = 0
  for i in countdown(lnums-1, 0):
    if str[i] in "0123456789":
      let num = parseNumRev(str[0..i])
      str.delete(i - ($(num)).len + 1, i)
      #echo str
      str.insert($(lnum+num-1000000), i - ($(num)).len + 1)
      #echo str
      offset = ($(lnum+num-1000000)).len() - ($(num)).len
      break
  
  str.delete(lnums - 1 + offset, rnume + offset + 1)
  str.insert("0", lnums - 1 + offset)

  var pos = 0
  #echo "to parse     ", str
  result = parse(str, pos)

proc explode(p: var Pair): bool = 
  var pos = 0
  #echo "EXPLO ", p.str
  result = explode(p, pos)
  if result:
    #echo "after expode ", p.str
    p = p.explode2
    #echo "after EXP2   ", p.str


#####################################################
proc split(p: var Pair): bool =
  if p.lnum > -1 and p.rnum > -1:
    if p.lnum > 9:
      p.lpair = pair(p.lnum div 2, p.lnum - (p.lnum div 2))
      p.lnum = -1
      return true
    if p.rnum > 9:
      p.rpair = pair(p.rnum div 2, p.rnum - (p.rnum div 2))
      p.rnum = -1
      return true
    return false
  if p.lnum < 0 and p.rnum < 0:
    if split(p.lpair):
      return true
    else:
      return split(p.rpair)
  if p.lnum > -1:
    if p.lnum > 9:
      p.lpair = pair(p.lnum div 2, p.lnum - (p.lnum div 2))
      p.lnum = -1
      return true
    else:
      return split(p.rpair)
  else:
    if split(p.lpair):
      return true
    else:
      if p.rnum > 9:
        p.rpair = pair(p.rnum div 2, p.rnum - (p.rnum div 2))
        p.rnum = -1
        return true
      else:
        return false

proc magnitude(p: Pair): int =
  if p.lnum > -1: result += 3 * p.lnum
  else: result += 3 * magnitude(p.lpair)
  
  if p.rnum > -1: result += 2 * p.rnum
  else: result += 2 * magnitude(p.rpair)


####################################
let input = readFile("input18.txt").splitLines()

# echo input[0]
# var pos = 0
# var p = parse(input[0], pos)
# p = p.add p
# echo p.str

# for input in ["[[[[[9,8],1],2],3],4]", "[7,[6,[5,[4,[3,2]]]]]", "[[6,[5,[4,[3,2]]]],1]", "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"]:
#   var pos = 0
#   var p = parse(input, pos)
#   assert p.explode(0)
#   #echo "be", p.str
#   p = explode2(p)
#   #echo "ki", p.str
#   assert p.str in ["[[[[0,9],2],3],4]", "[7,[6,[5,[7,0]]]]", "[[6,[5,[7,0]]],3]", "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[7,0]]]]"]

# var p1 = parse("[[[[4,3],4],4],[7,[[8,4],9]]]")
# var p2 = parse("[1,1]")
# var p3 = add(p1, p2)
# assert explode p3
# assert explode p3
# assert not explode p3
# assert split p3
# assert not explode p3
# assert split p3
# assert explode p3
# assert p3.str == "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"


proc reduce(p: var Pair): void =
  while true:
    if explode p: continue
    if not split p: break 

# var p = parse("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]")
# reduce p
# assert p.str == "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
# assert magnitude(parse("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")) == 3488


# var p = parse("[[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]")
# reduce p
# assert p.str == "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]"



var sum = parse(input[0])
for line in input[1..^1]:
  #echo "totalsum ", sum.str
  #echo "add ", str(parse line)
  sum = add(sum, parse line)
  #echo "after addition ", sum.str 
  reduce sum
  #echo "after reduction ", sum.str

echo str sum
echo magnitude sum

var maxmag = 0
for i in 0..99:
  echo i
  for j in 0 .. 99:
    var sum = add(parse(input[i]), parse(input[j]))
    reduce sum
    let mag = magnitude(sum)
    maxmag = max(maxmag, mag)

echo maxmag

import strutils, sequtils, std/strscans, algorithm, math, sets, tables, sugar
import aoctools

let input = readFile("input14.txt").splitLines()

var polimer = input[0]
let rulesin = input[2..101].toSeq.mapIt(it.scanTuple("$w -> $w"))
var rules: Table[string, char]

for (_, source, product) in rulesin:
 rules[source] = product[0]

var freqs: CountTable[string]
for ii in 0 .. polimer.len-2:
  freqs.inc(polimer[ii..ii+1])

#echo freqs

proc react(): void =
  var newFreq: CountTable[string]
  for source in freqs.keys:
    let product = rules.getOrDefault(source)
    if product != default(char):
      newFreq[source[0] & product] = newFreq[source[0] & product] + freqs[source]
      newFreq[product & source[1]] = newFreq[product & source[1]] + freqs[source]
    else:
      newFreq[source] = newFreq[source] + freqs[source]

  freqs = newFreq

for r in 1..40:
  echo r
  react()

var fresingle: CountTable[char]
fresingle.inc(polimer[^1])
for (s, n) in freqs.pairs:
  fresingle[s[0]] = fresingle[s[0]] + n

var min = high(int)
var max = 0
for(k, v) in fresingle.pairs:
  if v > max: max = v
  if v < min: min = v

echo max - min


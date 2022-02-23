var 
  x1 = 1
  x2 = 6
  random = 1
  s1, s2, rolls = 0

proc throw(): int =
  result = random
  inc random
  if random == 101: random = 1
  inc rolls

while true:
  for _ in 1..3: x1 += throw()
  while x1 > 10: x1 -= 10
  s1 += x1
  if s1 >= 1000:
    echo s2 * rolls
    break

  for _ in 1..3: x2 += throw()
  while x2 > 10: x2 -= 10
  s2 += x2
  if s2 >= 1000:
    echo s1 * rolls
    break

# Part 2.
const quantumrolls = [(3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1)]
var wins1 = 0
var wins2 = 0

proc play(x1, x2, score1, score2, phase, n : sink int): void =
  case phase:
    of 1:
      for (roll, times) in quantumrolls:
        play(x1 + roll, x2, score1, score2, 2, n * times)

    of 2:
      if x1 > 10: x1 -= 10
      score1 += x1
      if score1 >= 21: wins1 += n
      else: play(x1, x2, score1, score2, 3, n)

    of 3:
      for (roll, times) in quantumrolls:
        play(x1, x2 + roll, score1, score2, 4, n * times)

    of 4:
      if x2 > 10: x2 -= 10
      score2 += x2
      if score2 >= 21: wins2 += n
      else: play(x1, x2, score1, score2, 1, n)

    else: discard

play(1, 6, 0, 0, 1, 1)
echo max(wins1, wins2)

import strutils, sequtils, std/strscans, algorithm, math, sets, tables, sugar
import aoctools

var x, y, vx, vy:int

# target area: x=281..311, y=-74..-54
proc inArea(): bool =
  return 281 <= x and x <= 311 and -74 <= y and y <= -54
  #return 20 <= x and x <= 30 and -10 <= y and y <= -5

proc toContinue(): bool =
  if 311 < x or y < -74: return false
  #if 30 < x or y < -10: return false
  return true

proc step(): void =
  x += vx
  y += vy

  if vx > 0: dec vx
  dec vy

proc throw(ux, uy: int): int =
  x = 0
  y = 0
  vx = ux
  vy = uy
  var maxy = 0
  
  while (not inArea()) and toContinue():
    step()
    maxy = max(maxy, y)
  
  if inArea(): return maxy
  else: return -1

var highest = 0
forArea(0,-100,  100,100):
  highest = max(highest, throw(x, y))
echo highest

# var correct = 0
# forArea(0,-2000,  2000,2000):
#   if throw(x, y) > -1: inc correct
# echo correct

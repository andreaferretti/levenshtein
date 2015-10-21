import streams, strutils
import random

proc countLines(path: string): int =
  var
    input = newFileStream(path, fmRead)
    s = ""
  result = 0
  while readLine(input, s):
    result += 1

proc sample(inputPath, outputPath: string, prob: float) =
  var
    input = newFileStream(inputPath, fmRead)
    output = newFileStream(outputPath, fmWrite)
    s = ""
  defer:
    input.close()
    output.close()
  while readLine(input, s):
    if random() < prob:
      output.writeLine(s)

when isMainModule:
  const
    inputPath = "../words.txt"
    outputPath = "../words1000.txt"
  let
    lines = countLines(inputPath)
    prob = 1000.0 / lines.float
  sample(inputPath, outputPath, prob)
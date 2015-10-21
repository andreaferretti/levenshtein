import streams, strutils, times

proc readWords(path: string): seq[string] =
  result = @[]
  var
    input = newFileStream(path, fmRead)
    s = ""
  defer:
    input.close()
  while readLine(input, s):
    result.add(s)

iterator couples[A](xs: seq[A]): auto =
  for i in 0 .. < xs.len:
    for j in (i + 1) .. < xs.len:
      yield (xs[i], xs[j])

when isMainModule:
  let
    words = readWords("../words1000.txt")
    numCouples = words.len * (words.len - 1) / 2
  var total = 0'i64
  let start = epochTime()
  for a, b in couples(words):
    total += editDistance(a, b)
  let time = ((epochTime() - start) * 1000).int
  echo "The average Levenshtein distance is ", total.float / numCouples.float
  echo "The time to compute this was ", time, " ms"
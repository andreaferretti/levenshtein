import streams, times, memo, hashes

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

type ImmutableString = object
  content: ref string
  start: int
  hashValue: int

template hash(h: ImmutableString): int = h.hashValue

template head(h: ImmutableString): char = h.content[h.start]

proc tail(h: ImmutableString): ImmutableString =
  result.content = h.content
  result.start = h.start + 1
  result.hashValue = 0
  for i in result.start .. high(result.content[]):
    result.hashValue = result.hashValue !& ord(result.content[i])
  result.hashValue = !$(result.hashValue)

template len(h: ImmutableString): int = len(h.content[]) - h.start

proc lift(s: string): ImmutableString =
  new result.content
  result.content[] = s
  result.start = 0
  result.hashValue = hash(s)

proc lev(t: tuple[a, b: ImmutableString]): int {.memoized.} =
  let (a, b) = t
  if a.len == 0: return b.len
  if b.len == 0: return a.len
  let
    a1 = a.tail
    b1 = b.tail
    d1 = lev((a1, b)) + 1
    d2 = lev((a, b1)) + 1
    d3 = lev((a1, b1)) + (if a.head == b.head: 0 else: 1)
  return min(min(d1, d2), d3)

proc levenshtein(a, b: string): int =
  resetCache(lev)
  lev((a.lift, b.lift))

when isMainModule:
  let
    words = readWords("../words1000.txt")
    numCouples = words.len * (words.len - 1) / 2
  var total = 0'i64
  let start = epochTime()
  for a, b in couples(words):
    total += levenshtein(a, b)
  let time = ((epochTime() - start) * 1000).int
  echo "The average Levenshtein distance is ", total.float / numCouples.float
  echo "The time to compute this was ", time, " ms"
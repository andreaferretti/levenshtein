package lev.enshtein

object Levenshtein {
  def main(args: Array[String]): Unit = {
    val words = scala.io.Source.fromFile("../words1000.txt").getLines.toList
    println(s"words is ${words.length}")

    val start = System.currentTimeMillis
    var sum = 0
    val ds = words.combinations(2).foreach({ t =>
      val List(a, b) = t
      sum += dist((a, b))
    })
    val numPairs = words.length * (words.length - 1) / 2
    println(s"avg distance is ${(sum.toDouble / numPairs.toDouble)}")
    val end = System.currentTimeMillis
    val milliseconds = end - start
    println(s"it took $milliseconds")
  }

  import scalaz.Memo
  def dist: ((String, String)) => Int  = {
    lazy val memoLev: ((String, String)) => Int = Memo.mutableHashMapMemo { case t: (String, String) =>
      val (a, b) = t
      if(a.length == 0) b.length
      else if(b.length == 0) a.length
      else {
        val x = if(a.head == b.head) 0 else 1
        val d1 = memoLev(a, b.tail) + 1
        val d2 = memoLev(a.tail, b) + 1
        val d3 = memoLev(a.tail, b.tail) + x
        Math.min(Math.min(d1, d2), d3)
      }
    }
    memoLev
  }
}

package ro.cojocar.dan.recyclerview.dummy
import kotlin.random.Random
import java.util.*

object DummyContent {

  val ITEMS: MutableList<DummyItem> = ArrayList()

  val ITEM_MAP: MutableMap<String, DummyItem> = HashMap()

  private const val COUNT = 25
  var INDEX = 25
  init {
    // Add some sample items.
    for (i in 1..COUNT) {
      addItem(createDummyItem(i))
    }
  }

  private fun addItem(item: DummyItem) {
    ITEMS.add(item)
    ITEM_MAP[item.id] = item
  }

  private fun createDummyItem(position: Int): DummyItem {
    return DummyItem(position.toString(), Date(Random.nextInt(2022, 2023), Random.nextInt(1, 12), Random.nextInt(1, 30) + 1),  "Activity $position", Random.nextInt(1, 6),  "Location $position", "Some location notes presented here $position", Random.nextInt(1,10), Random.nextInt(1, 10), "Friends $position")
  }

  data class DummyItem(val id: String, var time: Date, var name: String, var duration: Int, var location: String, var notes: String, var mood: Int, var energy_level: Int, var friends: String) {
    override fun toString(): String = name
  }
}

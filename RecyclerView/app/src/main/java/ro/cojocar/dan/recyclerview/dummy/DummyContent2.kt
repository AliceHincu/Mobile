package ro.cojocar.dan.recyclerview.dummy

import android.os.Build
import androidx.annotation.RequiresApi
import java.time.LocalDate
import java.util.*
import kotlin.random.Random

@RequiresApi(Build.VERSION_CODES.O)
object DummyContent2 {

    val ITEMS: MutableList<DummyItem2> = ArrayList()

    val ITEM_MAP: MutableMap<String, DummyItem2> = HashMap()

    private const val COUNT = 25
    var INDEX = 25
    init {
        // Add some sample items.
        for (i in 1..COUNT) {
            addItem(createDummyItem(i))
        }
    }

    private fun addItem(item: DummyItem2) {
        ITEMS.add(item)
        ITEM_MAP[item.id] = item
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createDummyItem(position: Int): DummyItem2 {
        return DummyItem2(position.toString(), LocalDate.of(Random.nextInt(2022, 2023), Random.nextInt(1, 12), Random.nextInt(1, 30) + 1),  "Title $position", "Text $position",  "angry")
    }

    data class DummyItem2(val id: String, var date: LocalDate, var title: String, var text: String, var emotion: String) {
        override fun toString(): String = title
    }
}
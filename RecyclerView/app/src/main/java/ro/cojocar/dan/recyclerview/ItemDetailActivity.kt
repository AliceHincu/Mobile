package ro.cojocar.dan.recyclerview

import android.os.Build
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.MenuItem
import android.view.View
import android.widget.ArrayAdapter
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_item_detail.*
import kotlinx.android.synthetic.main.item_list.*
import kotlinx.android.synthetic.main.item_list_content.*
import ro.cojocar.dan.recyclerview.databinding.ActivityItemDetailBinding
import ro.cojocar.dan.recyclerview.dummy.DummyContent.INDEX
import ro.cojocar.dan.recyclerview.dummy.DummyContent2
import java.time.LocalDate
import java.util.*

class ItemDetailActivity : AppCompatActivity(), TextWatcher {
    var id_item: Int = 0
    val emotions = listOf("angry", "happy")

    private lateinit var binding: ActivityItemDetailBinding

    private var item: DummyContent2.DummyItem2? = null
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityItemDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val adapter = ArrayAdapter(this, R.layout.dropdown_item, emotions)
        binding.dropdownField.setAdapter(adapter)

        setSupportActionBar(detail_toolbar)
        fab.setOnClickListener(onClickListener)

        // Show the Up button in the action bar.
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        if (savedInstanceState == null) {
            // Create the detail fragment and add it to the activity
            // using a fragment transaction.
            id_item = intent.getStringExtra(ItemDetailFragment.ARG_ITEM_ID)?.toInt()!!
            val fragment = ItemDetailFragment().apply {
                arguments = Bundle().apply {
                    putString(
                        ItemDetailFragment.ARG_ITEM_ID,
                        intent.getStringExtra(ItemDetailFragment.ARG_ITEM_ID)
                    )
                }
            }

            supportFragmentManager.beginTransaction()
                .add(R.id.linear_layout, fragment)
                .commit()
        }
    }

    /**
     * When you click on the fab button
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private val onClickListener: View.OnClickListener = View.OnClickListener { view ->
        if (isValid()) {
            if(id_item != 999) {
                DummyContent2.ITEM_MAP[id_item.toString()]?.date =
                    LocalDate.now()
                DummyContent2.ITEM_MAP[id_item.toString()]?.title =
                    note_title_edit.text.toString()
                DummyContent2.ITEM_MAP[id_item.toString()]?.text =
                    note_text_edit.text.toString()
                DummyContent2.ITEM_MAP[id_item.toString()]?.emotion =
                    note_emotion_edit.editText?.text.toString()
                Log.d("TAG", "updated item no $id_item")

                Snackbar.make(view.rootView, "updated item no $id_item", Snackbar.LENGTH_LONG)
                    .setAction("Action", null).show()
                setResult(id_item)
                finish()
            } else {
                id_item += 1
                val dummy = DummyContent2.DummyItem2(
                    (DummyContent2.INDEX + 1).toString(),
                    LocalDate.now(),
                    note_title_edit.text.toString(),
                    note_text_edit.text.toString(),
                    note_emotion_edit.editText?.text.toString()
                )
                DummyContent2.ITEMS.add(dummy)
                DummyContent2.ITEM_MAP[(DummyContent2.INDEX+1).toString()] = dummy
                Log.d("TAG", "added item no ${dummy.id}")

                INDEX += 1
                setResult(DummyContent2.ITEMS.size - 1)
                finish()
            }
        }
    }

    private fun isValid() : Boolean {
        if (note_title_edit.text.toString().isEmpty()) {
            note_title_edit.error = "Please enter a title"
            return false
        }

        if (note_text_edit.text.toString().isEmpty()) {
            note_text_edit.error = "Please write the note"
            return false
        }

        if(note_emotion_edit.editText?.text.toString().isEmpty()) {
            note_emotion_edit.error = "Please select a mood"
            return false
        }

        return true
    }

    override fun onOptionsItemSelected(item: MenuItem) =
        when (item.itemId) {
            android.R.id.home -> {
                // This ID represents the Home or Up button. In the case of this
                // activity, the Up button is shown. Use NavUtils to allow users
                // to navigate up one level in the application structure. For
                // more details, see the Navigation pattern on Android Design:
                //
                // http://developer.android.com/design/patterns/navigation.html#up-vs-back

                //NavUtils.navigateUpTo(this, Intent(this, ItemListActivity::class.java))
                setResult(0)
                finish()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }

    override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
        //
    }

    override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
        //
    }

    override fun afterTextChanged(p0: Editable?) {
        //
    }
}

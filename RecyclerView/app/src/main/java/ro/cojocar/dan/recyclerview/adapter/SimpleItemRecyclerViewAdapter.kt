package ro.cojocar.dan.recyclerview.adapter

import android.app.AlertDialog
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.RequiresApi
import androidx.cardview.widget.CardView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.get
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.textview.MaterialTextView
import kotlinx.android.synthetic.main.item_list_content.view.*
import ro.cojocar.dan.recyclerview.ItemDetailActivity
import ro.cojocar.dan.recyclerview.ItemDetailFragment
import ro.cojocar.dan.recyclerview.R
import ro.cojocar.dan.recyclerview.dummy.DummyContent
import ro.cojocar.dan.recyclerview.dummy.DummyContent2

class SimpleItemRecyclerViewAdapter(
    private val values: MutableList<DummyContent2.DummyItem2>
) : RecyclerView.Adapter<SimpleItemRecyclerViewAdapter.ViewHolder>() {

    val emotionColorDict = mutableMapOf(
        "happy" to "#FFF599",
        "calm" to "#91F48F",
        "angry" to "#FF9E9E",
        "sad" to "#9EFFFF",
        "tired" to "#B69CFF"
    )

    /**
     * A short click = edit screen
     */
    private val onClickListener: View.OnClickListener = View.OnClickListener { v ->
        val item = v.tag as DummyContent2.DummyItem2 // casts the object to DummyItem.
        // starts edit action with existent id from clicked note
        val intent = Intent(v.context, ItemDetailActivity::class.java).apply {
            putExtra(ItemDetailFragment.ARG_ITEM_ID, item.id)
        }
        v.context.startActivity(intent)
    }

    /**
     * A long click = delete alert
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private val onLongClickListener: View.OnLongClickListener =  View.OnLongClickListener{ v ->
        val item = v.tag as DummyContent2.DummyItem2 // casts the object to DummyItem.
        val builder = AlertDialog.Builder(v.context)
        builder.setMessage("Are you sure you want to Delete?")
            .setCancelable(false)
            .setPositiveButton("Yes") { _, _ ->
                this.notifyItemRemoved(DummyContent2.ITEMS.indexOf(item))
                values.remove(item)
                DummyContent2.ITEM_MAP.remove(item.id)
                DummyContent2.ITEMS.remove(item)
                Snackbar.make(v, "Deleted", Snackbar.LENGTH_LONG)
                    .setAction("Action: deletion", null).show()
            }
            .setNegativeButton("No") { dialog, _ ->
                dialog.dismiss()
            }
        val alert = builder.create()
        alert.show()
        true
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_list_content, parent, false)
        return ViewHolder(view)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = values[position]

        holder.titleView.text = item.title
        holder.textView.text = item.text
        holder.dateView.text = item.date.toString()


        holder.emotionView.background.setTint(Color.parseColor(emotionColorDict[item.emotion]))
        with(holder.itemView) {
            tag = item
            setOnClickListener(onClickListener)
            setOnLongClickListener(onLongClickListener)
        }
        with(holder.itemView) {
            tag = item
            setOnLongClickListener(onLongClickListener)
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getItemCount() = DummyContent2.ITEMS.size

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val titleView: MaterialTextView = view.note_title
        val textView: MaterialTextView = view.note_text
        val dateView: MaterialTextView = view.note_date
        val emotionView: ConstraintLayout = view.note_background
    }
}
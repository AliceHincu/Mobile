package ro.cojocar.dan.recyclerview

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_item_detail.*
import kotlinx.android.synthetic.main.activity_item_list.*
import kotlinx.android.synthetic.main.activity_item_list.fab
import kotlinx.android.synthetic.main.item_list.*
import kotlinx.android.synthetic.main.item_list_content.view.*
import ro.cojocar.dan.recyclerview.adapter.SimpleItemRecyclerViewAdapter
import ro.cojocar.dan.recyclerview.dummy.DummyContent2

class ItemListActivity : AppCompatActivity() {
  @RequiresApi(Build.VERSION_CODES.O)
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_item_list)

    setSupportActionBar(toolbar)

    fab.setOnClickListener(onClickListener)

    setupRecyclerView(item_list)
  }

  /**
   * When you click on the fab button, start another activity which is the addition of a new note
   */
  private val onClickListener: View.OnClickListener = View.OnClickListener { v ->
    val intent = Intent(v.context, ItemDetailActivity::class.java).apply {
      putExtra(ItemDetailFragment.ARG_ITEM_ID, "999")
    }
    startActivityForResult(intent, 123)
  }

  @RequiresApi(Build.VERSION_CODES.O)
  private fun setupRecyclerView(recyclerView: RecyclerView) {
    recyclerView.adapter = SimpleItemRecyclerViewAdapter(DummyContent2.ITEMS)  // populate item list
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data:Intent?) {

    super.onActivityResult(requestCode, resultCode, data)
    if(resultCode != 0 && requestCode == 123) {
      item_list.adapter?.notifyItemInserted(resultCode)
    }
  }

  @SuppressLint("NotifyDataSetChanged")
  override fun onResume() {
    super.onResume()
    item_list.adapter?.notifyDataSetChanged()
  }


}

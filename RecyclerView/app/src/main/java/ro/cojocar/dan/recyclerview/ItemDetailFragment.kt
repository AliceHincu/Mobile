package ro.cojocar.dan.recyclerview

import android.os.Build
import android.os.Bundle
import android.text.Editable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import androidx.annotation.RequiresApi
import androidx.fragment.app.Fragment
import kotlinx.android.synthetic.main.activity_item_detail.*
import ro.cojocar.dan.recyclerview.dummy.DummyContent2
import java.time.format.DateTimeFormatter
import java.util.*

class ItemDetailFragment : Fragment() {


  private var item: DummyContent2.DummyItem2? = null

  @RequiresApi(Build.VERSION_CODES.O)
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    arguments?.let {
      if (it.containsKey(ARG_ITEM_ID)) {
        // Load the dummy content specified by the fragment arguments (the item id in this case).
        // In a real-world scenario, use a Loader to load content from a content provider.
        if(it.getString(ARG_ITEM_ID) == "999") {
            populateNoteWithNewData()
        } else {
            populateNoteWithExistingData(it)
        }
      }
    }
  }

  @RequiresApi(Build.VERSION_CODES.O)
  private fun populateNoteWithExistingData(bundle: Bundle) {
    item = DummyContent2.ITEM_MAP[bundle.getString(ARG_ITEM_ID)]

    val formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy")
    activity?.detail_toolbar?.title = "Last updated: " + item?.date?.format(formatter)
    activity?.note_title_edit?.setText(item?.title)

    activity?.dropdown_field?.setText(item?.emotion)
    activity?.note_text_edit?.setText(item?.text)
  }

  @RequiresApi(Build.VERSION_CODES.O)
  private fun populateNoteWithNewData() {
    activity?.detail_toolbar?.title = "Last updated: -"
  }

  override fun onCreateView(
      inflater: LayoutInflater, container: ViewGroup?,
      savedInstanceState: Bundle?
  ): View? {
    val rootView = inflater.inflate(R.layout.item_detail, container, false)
    return rootView
  }

  companion object {
    const val ARG_ITEM_ID = "item_id"
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note item;
  final Future<String> Function(Note) onSubmit;

  NoteDetail({super.key, required this.item, required this.appBarTitle, required this.onSubmit});

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState();
  }
  
}

class NoteDetailState extends State<NoteDetail>{
  static var _emotions = ['angry', 'happy', 'calm', 'sad', 'innovative'];

  String error = "";
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    descriptionController.text = widget.item.description;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const Text("Is loading...");
    }

    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
          appBar: AppBar(
            title: Text(widget.appBarTitle),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen(0);
                }
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              // FIRST ELEMENT
              children: [

                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                      [ const Text('Emotion: '),
                        Container(width: 8),
                        DropdownButton(
                          items: _emotions.map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item, style: TextStyle(color: (item == _emotions[widget.item.emotion] ? Colors.white : Colors.black))) // so that the sown emotion is white and the rest are blac on the dd
                          )).toList(),
                          style: TextStyle(color: Colors.white),
                          value: getEmotionAsString(widget.item.emotion),
                          onChanged: (selectedValue) {
                            setState(() {
                              debugPrint('User selected $selectedValue');
                              updateEmotionAsInt(selectedValue!);
                            });
                          },
                        )
                    ]
                ),

                // SECOND ELEMENT
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child:  TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Something changed in Title Text Field");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                    ),
                  ),
                ),

                // THIRD ELEMENT
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child:  TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Something changed in Description Text Field");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                    ),
                  ),
                ),

                // FOURTH ELEMENT
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                            child: const Text("Save", textScaleFactor: 1.5,),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                _save();
                              });
                            },
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
  }

  void moveToLastScreen(int result) {
    Navigator.pop(context, result);
  }

  void updateEmotionAsInt(String value) {
    switch (value) {
      case 'angry':
        widget.item.emotion = 0;
        break;
      case 'happy':
        widget.item.emotion = 1;
        break;
      case 'calm':
        widget.item.emotion = 2;
        break;
      case 'sad':
        widget.item.emotion = 3;
        break;
      case 'innovative':
        widget.item.emotion = 4;
        break;
    }
  }

  String getEmotionAsString(int value) {
    debugPrint(value.toString());
    return _emotions[value];
  }

  void updateTitle() {
    widget.item.title = titleController.text;
  }

  void updateDescription() {
    widget.item.description = descriptionController.text;
  }

  void _save() async {
    setState(() => isLoading = true);

    String title = widget.item.title;
    String description = widget.item.description;
    String date = DateFormat.yMMMd().format(DateTime.now());
    int emotion = widget.item.emotion;

    // validations
    bool isValid = true;
    String errorText = '';
    if(widget.item.title.isEmpty){
      isValid = false;
      errorText += "Title can't be empty\n";
    }
    if(widget.item.description.isEmpty){
      isValid = false;
      errorText += "Description can't be empty\n";
    }

    if(!isValid) {
      _showAlterDialog("Error", errorText);
      setState(() => isLoading = false);
      return;
    }

    error = "";
    error = await widget.onSubmit(widget.item);

    if (error != "") {
      widget.item.title = title;
      widget.item.description = description;
      widget.item.date = date;
      widget.item.emotion = emotion;
      _showAlterDialog('Status', 'Problem Saving on Server, but it will be saved locally.');
      setState(() => isLoading = false);
      return;
    }

    _showAlterDialog('Status', 'Note Saved Successfully on Server');
    setState(() => isLoading = false);

    goBack(context);
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void _showAlterDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title, style: const TextStyle(color: Colors.black)),
      content: Text(message, style: const TextStyle(color: Colors.black)),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}
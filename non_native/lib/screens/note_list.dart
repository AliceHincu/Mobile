import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:non_native/repository/database.dart';
import 'package:non_native/screens/note_detail.dart';
import 'package:non_native/theme/constants.dart';

import '../domain/logger.dart';
import '../domain/message.dart';
import '../domain/message_type.dart';
import '../domain/webSocketClient.dart';
import '../models/note.dart';

class NoteList extends StatefulWidget {
  NoteList({super.key});

  final WebSocketClient client = WebSocketClient.getInstance();

  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  List<Note> items = [];
  bool isLoading = false;
  String error = "";

  int count = 1;
  Map mapColors = <int, Color>{
    0: Colors.redAccent,
    1: Colors.yellowAccent,
    2: Colors.green,
    3: Colors.lightBlueAccent,
    4: Colors.pinkAccent
  };

  @override
  void initState() {
    super.initState();

    widget.client.refreshNotes  = refreshNotes;
    widget.client.addNoteLocally = addNoteLocally;
    widget.client.connectToSocket();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    error = "";
    try {
      items = await LocalDatabase.instance.readAllNotes();
    } catch (e) {
      error = "Failed to read items from database\n"
          "ERROR: ${e.toString()}";
    }

    setState(() => isLoading = false);
  }

  Future addNoteLocally(Note item) async {
    error = "";
    try {
      Note note = await LocalDatabase.instance.create(item);
      items.add(note);
      logger.v("[LOCAL] Note $note has been created");
    } catch (e) {
      setState(() {});
      logger.e("[LOCAL][ERROR] ${e.toString()}");
      error += e.toString();
    }

    setState(() {});
  }

  Future<String> addNote(Note item) async {
    error = "";
    try {
      if (!widget.client.isConnected) {
        throw Exception("Cannot create note. There is no connection to the server.");
      }
      widget.client.subscribe(jsonEncode(Message<Note>(type: MessageType.CREATE, data: item)));
    } catch (e) {
      setState(() {});
      addNoteLocally(item);
      logger.e("[LOCAL][ERROR] ${e.toString()}");
      return e.toString();
    }
    setState(() {});
    return "";
  }

  Future<String> updateNote(Note item) async {
    error = "";
    try {
      await LocalDatabase.instance.update(item);
      logger.v("[LOCAL] Note with id $item has been updated");
      widget.client.subscribe(jsonEncode(Message<Note>(type: MessageType.UPDATE, data: item)));
    } catch (e) {
      setState(() {});
      logger.e("[LOCAL][ERROR] ${e.toString()}");
      return e.toString();
    }
    setState(() {});
    return "";
  }

  void deleteNote(int index) async {
    setState(() => isLoading = true);

    error = "";
    int? id = items[index].id;
    if (id == null) {
      error = "Delete error: element id is null!";
      setState(() => isLoading = false);
      logger.e("[LOCAL][ERROR] $error");
      return;
    }

    try {
      await LocalDatabase.instance.delete(id);
      bool found = false;
      for (Note n in items){
        if (n.id == id) {
          found = true;
          items.removeAt(index);
          break;
        }
      }

      if (!found) {
        throw Exception("Cannot delete note.");
      }
      logger.v("[LOCAL] Note with id $id has been deleted");

      widget.client.subscribe(jsonEncode(Message<int>(type: MessageType.DELETE, data: id)));
    } catch (e) {
      error = "Failed to remove item with id $id from database\n"
          "ERROR: ${e.toString()}";
      logger.e("[LOCAL][ERROR] $error");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const Text("Is loading...");
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      // body: getNoteListView(),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // HERE YOU ADD
          final now = DateTime.now();
          String formatter = DateFormat('yMd').format(now);// 28/03/2020
          goToDetails(context, Note(title: "", description: "", date: formatter, emotion: 1), "Add Note", addNote);
          // navigateToNoteAddScreen(Note('', '', '', 0), 'Add Note');
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getNoteListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.headline4;
    TextStyle? descriptionStyle =
        const TextStyle(color: Colors.black, fontSize: 20);
    //Theme.of(context).textTheme.bodyMedium;
    TextStyle? dateStyle = Theme.of(context).textTheme.bodySmall;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int position) {
        return SizedBox(
          height: cardHeight,
          child: GestureDetector(
            child: Card(
              margin: const EdgeInsets.only(
                  left: cardMargin, right: cardMargin, top: cardMargin),
              color: mapColors[items[position].emotion],
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: cardPaddingH, vertical: cardPaddingV),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        items[position].title,
                        style: titleStyle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        items[position].description,
                        style: descriptionStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                          // to make the date go bottom down
                          child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(items[position].date,
                            style: dateStyle),
                      ))
                    ],
                  )),
            ),
            onTap: () {
              logger.d("[LOCAL][DEBUG] Card ${items[position].title} tapped");
              goToDetails(context, items[position], "Update Note", updateNote);
            },
            onLongPress: () {
              showAlertDialog(context, position);
            },
          ),
        );
      });
        }


  showAlertDialog(BuildContext context, int position) {
    Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () => Navigator.of(context).pop() // dismiss dialog,
        );

    Widget continueButton = TextButton(
        child: const Text("Delete"),
        onPressed: () => {deleteNote(position), Navigator.of(context).pop()});

    AlertDialog alert = AlertDialog(
      title: const Text("Alert Dialog", style: TextStyle(color: Colors.black)),
      content: const Text(
          "Would you really like to delete this note or your finger just got bored?",
          style: TextStyle(color: Colors.black)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void goToDetails(BuildContext context, Note item, String title, Future<String> Function(Note) onSubmit) {
    error = "";
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetail(item: item, appBarTitle: title, onSubmit: onSubmit)),
    );
  }
}

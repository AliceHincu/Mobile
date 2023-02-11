import 'package:flutter/material.dart';
import 'package:non_native/models/note_list_model.dart';
import 'package:non_native/screens/note_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "DreamKeeper",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0x00252525),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
        )
      ),
      home: NoteList()
    );
  }
}
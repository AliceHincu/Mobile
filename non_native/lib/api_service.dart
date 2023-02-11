// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'config.dart';
// import 'models/note.dart';
//
// class APIService {
//   static var client = http.Client();
//
//   static Future<List<Note>?> getNotes() async {
//     Map<String, String> requestHeaders = {
//       'Content-Type': 'application/json'
//     };
//
//     var url = Uri.http(Config.apiURL, Config.noteURL);
//
//     var response = await client.get(url, headers: requestHeaders);
//
//     if(response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       // return notesFromJson(data["data"]);
//       return null;
//     } else {
//       return null;
//     }
//   }
//
//   static Future<bool> saveNote(Note model, bool isEditMode) async {
//     var noteURL = Config.noteURL;
//
//     if(isEditMode) {
//       noteURL = "$noteURL/${model.id}";
//     }
//
//     var url = Uri.http(Config.apiURL, noteURL);
//
//     var requestMethod = isEditMode ? "PUT" : "POST";
//
//     var request = http.MultipartRequest(requestMethod, url);
//     request.fields["title"] = model.title;
//     request.fields["description"] = model.description;
//     request.fields["emotion"] = model.emotion as String;
//
//     var response = await request.send();
//
//     if(response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   static Future<bool> deleteNote(noteId) async {
//     Map<String, String> requestHeaders = {
//       'Content-Type': 'application/json'
//     };
//
//     var url = Uri.http(Config.apiURL, "${Config.noteURL}/$noteId");
//
//     var response = await client.delete(url, headers: requestHeaders);
//
//     if(response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
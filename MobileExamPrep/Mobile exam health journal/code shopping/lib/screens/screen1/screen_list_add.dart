import 'package:code_shopping/models/symptom.dart';
import 'package:code_shopping/screens/screen1/screen1_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../repo/repo.dart';
import '../../utils/utils.dart';

class AddEntityScreen extends StatefulWidget {
  final Screen1ViewModel screen1ViewModel;

  const AddEntityScreen({Key? key, required this.screen1ViewModel})
      : super(key: key);

  @override
  State<AddEntityScreen> createState() => _AddEntityScreenState();
}

class _AddEntityScreenState extends State<AddEntityScreen> {
  late Screen1ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = widget.screen1ViewModel;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Add Entity'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              AddEntityForm(screen1ViewModel: _viewModel),
            ],
          ),
        ));
  }
}

final _formKey = GlobalKey<FormState>();

class AddEntityForm extends StatefulWidget {
  final Screen1ViewModel screen1ViewModel;

  const AddEntityForm({Key? key, required this.screen1ViewModel}) : super(key: key);

  @override
  State<AddEntityForm> createState() => _AddEntityFormState();
}

class _AddEntityFormState extends State<AddEntityForm> {
  late Screen1ViewModel viewModel;
  // late String studentName;

  //todo change
  String date = "";
  String symptom = "";
  String medication = "";
  String dosage = "";
  String doctor = "";
  String notes = "";

  @override
  Widget build(BuildContext context) {
    var dateEdit = TextEditingController();
    var medicationEdit = TextEditingController();
    var symptomEdit = TextEditingController();
    var dosageEdit = TextEditingController();
    var doctorEdit = TextEditingController();
    var notesEdit = TextEditingController();
    viewModel = widget.screen1ViewModel;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: dateEdit,
            decoration: const InputDecoration(
              labelText: "date",
            ),
            onChanged: (value) => {date = value},
          ),
          TextFormField(
            controller: symptomEdit,
            decoration: const InputDecoration(
              labelText: "symptom",
            ),
            onChanged: (value) => {symptom = value},
          ),
          TextFormField(
            controller: medicationEdit,
            decoration: const InputDecoration(
              labelText: "medication",
            ),
            onChanged: (value) => {medication = value},
          ),
          TextFormField(
            controller: dosageEdit,
            decoration: const InputDecoration(
              labelText: "dosage",
            ),
            onChanged: (value) => {dosage = value},
          ),
          TextFormField(
            controller: doctorEdit,
            decoration: const InputDecoration(
              labelText: "doctor",
            ),
            onChanged: (value) => {doctor = value},
          ),
          TextFormField(
            controller: notesEdit,
            decoration: const InputDecoration(
              labelText: "notes",
            ),
            onChanged: (value) => {notes = value},
          ),
          ElevatedButton(
              onPressed: () async {
                var isConnected = await Utils.checkInternetConnection;
                if (isConnected == false) {
                  Fluttertoast.showToast(
                      msg: "No internet ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                } else {
                  print(date);
                  print(medication);
                  print(symptom);
                  print(medication);
                  print(dosage);
                  print(doctor);

                  viewModel.addEntity(Symptom(
                      date: dateEdit.text,
                      symptom: symptom,
                      medication: medication,
                      dosage: dosage,
                      doctor: doctor,
                      notes: notes
                  )).then((value) =>
                  {
                    Navigator.pop(context)
                  });
                  Fluttertoast.showToast(
                      msg: "Added entity ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  dateEdit.clear();
                  medicationEdit.clear();
                  symptomEdit.clear();
                  doctorEdit.clear();
                  dosageEdit.clear();
                  notesEdit.clear();
                }
              },
              child: const Text("Save")),
        ],
      ),
    );
  }
}

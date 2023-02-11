import 'package:code_shopping/models/my_entity.dart';
import 'package:code_shopping/screens/screen1/screen1_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../repo/repo.dart';
import '../../utils/utils.dart';
import 'package:intl/intl.dart';

class AddEntityScreen extends StatefulWidget {
  final ViewModel screen1ViewModel;

  const AddEntityScreen({Key? key, required this.screen1ViewModel})
      : super(key: key);

  @override
  State<AddEntityScreen> createState() => _AddEntityScreenState();
}

class _AddEntityScreenState extends State<AddEntityScreen> {
  late ViewModel _viewModel;

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
  final ViewModel screen1ViewModel;

  const AddEntityForm({Key? key, required this.screen1ViewModel}) : super(key: key);

  @override
  State<AddEntityForm> createState() => _AddEntityFormState();
}

class _AddEntityFormState extends State<AddEntityForm> {
  late ViewModel viewModel;
  // late String studentName;

  //todo change
  String name = "";
  String description = "";
  String category = "";
  String date = "";
  int time = 0;
  String intensity = "";

  @override
  Widget build(BuildContext context) {
    var nameEdit = TextEditingController();
    var categoryEdit = TextEditingController();
    var descriptionEdit = TextEditingController();
    var dateEdit = TextEditingController();
    var timeEdit = TextEditingController();
    var intensityEdit = TextEditingController();
    viewModel = widget.screen1ViewModel;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameEdit,
            decoration: const InputDecoration(
              labelText: "name",
            ),
            onChanged: (value) => {name = value},
          ),
          TextFormField(
            controller: descriptionEdit,
            decoration: const InputDecoration(
              labelText: "description",
            ),
            onChanged: (value) => {description = value},
          ),
          TextFormField(
            controller: categoryEdit,
            decoration: const InputDecoration(
              labelText: "category",
            ),
            onChanged: (value) => {category = value},
          ),
          TextFormField(
            controller: dateEdit,
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: "date" //label text of field
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context, initialDate: DateTime.now(),
                  firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101)
              );

              if(pickedDate != null ){
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                dateEdit.text = formattedDate;
                date = formattedDate;
              }else{
                print("Date is not selected");
              }
            },
            onChanged: (value) => {date = value},
          ),
          TextFormField(
            controller: timeEdit,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(
              labelText: "time",
            ),
            onChanged: (value) => {time = value as int},
          ),
          TextFormField(
            controller: intensityEdit,
            decoration: const InputDecoration(
              labelText: "intensity",
            ),
            onChanged: (value) => {intensity = value},
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
                  print(name);
                  print(category);
                  print(description);
                  print(category);
                  print(date);
                  print(time);

                  viewModel.addEntity(MyEntity(
                      name: nameEdit.text,
                      description: description,
                      category: category,
                      date: date,
                      time: time,
                      intensity: intensity
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
                  nameEdit.clear();
                  categoryEdit.clear();
                  descriptionEdit.clear();
                  timeEdit.clear();
                  dateEdit.clear();
                  intensityEdit.clear();
                }
              },
              child: const Text("Save")),
        ],
      ),
    );
  }
}

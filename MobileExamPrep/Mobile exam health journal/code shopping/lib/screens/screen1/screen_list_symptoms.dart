import 'package:code_shopping/models/symptom.dart';
import 'package:code_shopping/screens/screen1/screen1_view_model.dart';
import 'package:code_shopping/screens/screen1/tile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../repo/repo.dart';
import '../../theme/app_colors.dart';
import '../../utils/utils.dart';

class ShowList2 extends StatefulWidget {
  final Screen1ViewModel viewModel;
  final String date;

  const ShowList2({Key? key, required this.viewModel, required this.date})
      : super(key: key);

  @override
  State<ShowList2> createState() => _ShowList2State();
}

class _ShowList2State extends State<ShowList2> {
  late Screen1ViewModel viewModel;
  late String date;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = widget.viewModel;
    date = widget.date;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "All symptoms from $date",
        style: const TextStyle(fontSize: 30),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: FutureBuilder<bool>(
          future: Utils.checkInternetConnection,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.data == false && Repo.hasSync2 == false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "It seems there is a problem with your internet connection.",
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () => setState(() {}),
                              child: const Text(
                                "Retry",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ))
                        ],
                      )
                    : FutureBuilder<List<Symptom>>(
                        future: viewModel.getSymptomsForDate(date),
                        builder: (context, snapshot2) {
                          return snapshot2.connectionState ==
                                  ConnectionState.waiting
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView(
                                  children: snapshot2.data!
                                      .map(
                                        (entity) => Tile(
                                          entity: entity,
                                          onTap: () async {
                                            var isConnected = await Utils.checkInternetConnection;
                                            // viewModel
                                            //     .deleteEntity(entity.id!)
                                            //     .then((_) => setState(() {}));
                                            // Navigator.of(context).pop;
                                            // viewModel.deleteEntity( entity.id!).then((_) => setState(() {}));

                                            if (isConnected == true) {
                                              viewModel
                                                  .deleteEntity(entity.id!)
                                                  .then((_) => setState(() {}));
                                              if (context.mounted) Navigator.of(context).pop;
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             EditScreen(id: p.id!, screen1viewModel: viewModel)))
                                              //     .then((_) => setState(() {}));
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "No internet ",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );
                                            }
                                          },
                                        ),
                                      )
                                      .toList(),
                                );
                        },
                      );
          },
        ),
      ),
    );
  }
}

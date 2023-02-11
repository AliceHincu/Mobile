import 'package:code_shopping/screens/screen1/screen1_view_model.dart';
import 'package:code_shopping/screens/screen1/screen_list_entities.dart';
import 'package:code_shopping/screens/screen1/tile_entity.dart';
import 'package:code_shopping/screens/screen1/tile_date.dart';
import 'package:flutter/material.dart';

import '../../repo/repo.dart';
import '../../utils/utils.dart';

class ShowList extends StatefulWidget {
  final ViewModel viewModel;

  const ShowList({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  late ViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = widget.viewModel;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "All categories",
        style: TextStyle(fontSize: 30),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: FutureBuilder<bool>(
          future: Utils.checkInternetConnection,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data == false && Repo.hasSync1 == false) {
                // not available offline
                return Column(
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
                );
              } else {
                // we are online
                return FutureBuilder<List<String>>(
                  future: viewModel.getDates(),
                  builder: (context, snapshot2) {
                    return snapshot2.connectionState == ConnectionState.waiting // loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView(
                            children: snapshot2.data!
                                .map(
                                  (entity) => Tile2(
                                    myEntity: entity,
                                    onTap: () async {
                                      // var isConnected =
                                      //     await Utils.checkInternetConnection;
                                      // if (isConnected == true) {

                                      print("YOU TAPPED $entity");
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ShowList2(
                                                    viewModel: viewModel,
                                                    date: entity,
                                                  )))
                                          .then((_) => setState(() {}));

                                      // } else {
                                        // showDialog(
                                        //     context: context,
                                        //     builder: (context) =>
                                        //         const AlertDialog(
                                        //             backgroundColor: AppColors
                                        //                 .backgroundColor,
                                        //             title: Center(
                                        //                 child: Text(
                                        //               "Function is disabled due to lack of internet connection",
                                        //               style: TextStyle(
                                        //                   color: Colors.black),
                                        //             ))));
                                      // }
                                    },
                                  ),
                                )
                                .toList(),
                          );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}

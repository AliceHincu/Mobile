import 'package:code_shopping/screens/screen1/screen1_view_model.dart';
import 'package:code_shopping/screens/screen1/screen_list_add.dart';
import 'package:code_shopping/screens/screen1/tile_entity.dart';
import 'package:code_shopping/screens/screen2/tile_progress.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../models/my_entity.dart';
import '../../repo/repo.dart';
import '../../utils/utils.dart';
import 'edit_screen.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final ViewModel _viewModel = ViewModel(serviceLocator<Repo>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Intensity section",
        style: TextStyle(fontSize: 30),
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
                : snapshot.data == false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "You can only see the progress online.",
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
                              )),
                        ],
                      )
                    : FutureBuilder<List<MyEntity>>(
                        future: _viewModel.top10Activities(),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState !=
                                  ConnectionState.waiting &&
                              snapshot2.data != null) {
                            return ListView(
                              children: snapshot2.data!
                                  .map((entity) => ListTile(
                                        title: Text(entity.category!),
                                        subtitle: Text(entity.intensity!),
                                        onTap: () => {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditScreen(
                                                        viewModel: _viewModel,
                                                        id: entity.id!,
                                                      )))
                                              .then((_) => setState(() {}))
                                        },
                                      ))
                                  .toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
          },
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:code_shopping/models/my_entity.dart';
import 'package:code_shopping/repo/repo.dart';
import 'package:code_shopping/screens/screen1/screen1.dart';
import 'package:code_shopping/screens/screen2/borrow_screen.dart';
import 'package:code_shopping/screens/screen2/screen2.dart';
import 'package:code_shopping/screens/screen3/report_screen.dart';
import 'package:code_shopping/screens/screen3/report_view_model.dart';
import 'package:code_shopping/screens/screen3/screen3.dart';
import 'package:code_shopping/screens/screen4/screen4.dart';
import 'package:code_shopping/utils/utils.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:web_socket_channel/io.dart';

import 'database/database.dart';
import 'locator.dart';

import 'networking/rest_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  final database = await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
  final dao = database.myEntityDao;

  Repo.dao = dao;
  final dio = Dio();
  dio.options.headers["Demo-Header"] = "demo header";

  Repo.client = RestClient(dio);
  Repo.logger =  Logger();

  // ReportVM myBackend = serviceLocator<ReportViewModel>();
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   myBackend.sendError(error, stack);
  //   return true;
  // };


  Timer.periodic(const Duration(seconds: 1), (Timer t) => Utils.checkInternetConnection);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Parking App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const MyHomePage(title: 'Menu'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IOWebSocketChannel ws;

  @override
  void initState() {
    super.initState();

    // todo make sure its connected to internet
    ws = IOWebSocketChannel.connect(
      Uri.parse('ws://192.168.43.20:8080'),
    );

    ws.stream.listen((event) {
      print(event);
      var entity = MyEntity.fromJson(json.decode(event.toString()));
      print(entity);
      print("i have arrived");
      showSimpleNotification(
        Text("new health data!\n data has id ${entity.id!}"),
        background: Colors.purple,
      );
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: Center(
        child: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Screen1()),
                    );
                  },
                  child: const Text("Main section"),
                )),
            Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Screen2()),
                    );
                  },
                  child: const Text("Intensity section"),
                )),
            // Container(
            //     margin: const EdgeInsets.all(10),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const Screen3()),
            //         );
            //       },
            //       child: const Text("Top section"),
            //     )
            // ),
            // Container(
            //     margin: const EdgeInsets.all(10),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const Screen4()),
            //         );
            //       },
            //       child: const Text("Weekly section"),
            //     )
            // ),
          ],
        ),
      ),
    );
  }
}

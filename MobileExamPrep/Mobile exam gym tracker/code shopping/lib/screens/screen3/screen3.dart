// import 'package:code_shopping/screens/screen1/screen1_view_model.dart';
// import 'package:code_shopping/screens/screen1/screen_list_add.dart';
// import 'package:code_shopping/screens/screen1/tile_entity.dart';
// import 'package:code_shopping/screens/screen2/tile_progress.dart';
// import 'package:flutter/material.dart';
//
// import '../../locator.dart';
// import '../../models/my_entity.dart';
// import '../../repo/repo.dart';
// import '../../utils/utils.dart';
//
// class Screen3 extends StatefulWidget {
//   const Screen3({super.key});
//
//   @override
//   State<Screen3> createState() => _Screen3State();
// }
//
// class _Screen3State extends State<Screen3> {
//   final Screen1ViewModel _viewModel = Screen1ViewModel(serviceLocator<Repo>());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text(
//             "Top section",
//             style: TextStyle(fontSize: 30),
//           )),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: FutureBuilder<bool>(
//           future: Utils.checkInternetConnection,
//           builder: (context, snapshot) {
//             return snapshot.connectionState == ConnectionState.waiting
//                 ? const Center(
//               child: CircularProgressIndicator(),
//             )
//                 : snapshot.data == false
//                 ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "You can only see the progress online.",
//                   style: TextStyle(
//                     fontSize: 21,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 TextButton(
//                     onPressed: () => setState(() {}),
//                     child: const Text(
//                       "Retry",
//                       style: TextStyle(
//                         fontSize: 20,
//                       ),
//                     )),
//               ],
//             )
//                 : FutureBuilder<Map>(
//               future: _viewModel.top3Doctors(),
//               builder: (context, snapshot2) {
//                 if (snapshot2.connectionState != ConnectionState.waiting && snapshot2.data != null) {
//                   return ListView.builder(
//                       itemCount: snapshot2.data!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         String key =
//                         snapshot2.data!.keys.elementAt(index);
//                         return Column(
//                           children: <Widget>[
//                             ListTile(
//                               title: Text(key),
//                               subtitle:
//                               Text("${snapshot2.data![key]}"),
//                             ),
//                             const Divider(
//                               height: 2.0,
//                             ),
//                           ],
//                         );
//                       });
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

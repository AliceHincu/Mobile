import 'package:code_shopping/screens/screen1/screen1_view_model.dart';
import 'package:code_shopping/screens/screen1/screen_list_add.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import '../../models/my_entity.dart';
import '../../repo/repo.dart';
import 'screen_list_categories.dart';
import 'my_borrowed_books.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final ViewModel _viewModel = ViewModel(serviceLocator<Repo>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Main Section'),
        ),
        body: Center(
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
                            builder: (context) => AddEntityScreen(
                              screen1ViewModel: _viewModel,
                            )),
                      );
                    },
                    child: const Text("Add entity"),
                  )),
              Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowList(viewModel: _viewModel)),
                      );
                    },
                    child: const Text("See all categories"),
                  )),
              // Container(
              //     margin: const EdgeInsets.all(10),
              //     child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => Screen3()),
              //         );
              //       },
              //       child: const Text("Report section"),
              //     )
              // ),
            ],
          ),
        ),
    );
  }
}
//
// final _formKey = GlobalKey<FormState>();
//
// class BookForm extends StatefulWidget {
//   final Screen1ViewModel ownerViewModel;
//
//   const BookForm({Key? key, required this.ownerViewModel}) : super(key: key);
//
//   @override
//   State<BookForm> createState() => _BookFormState();
// }
//
// class _BookFormState extends State<BookForm> {
//   late Screen1ViewModel viewModel;
//
//   String number = "";
//   String address = "";
//   String status = "";
//   int count = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     var numberEdit = TextEditingController();
//     var statusEdit = TextEditingController();
//     var addressEdit = TextEditingController();
//     var countEdit = TextEditingController();
//     viewModel = widget.ownerViewModel;
//
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           const Text("Title"),
//           TextFormField(
//             controller: numberEdit,
//             decoration: const InputDecoration(
//               labelText: "Number",
//             ),
//             onChanged: (value) => {number = value},
//           ),
//           const Text("Status"),
//           TextFormField(
//             controller: statusEdit,
//             decoration: const InputDecoration(
//               labelText: "Status",
//             ),
//             onChanged: (value) => {status = value},
//           ),
//           const Text("Pages"),
//           TextFormField(
//             controller: addressEdit,
//             decoration: const InputDecoration(
//               labelText: "Address",
//             ),
//             onChanged: (value) => {address = value},
//           ),
//           const Text("count"),
//           TextFormField(
//             controller: countEdit,
//             decoration: const InputDecoration(
//               labelText: "count",
//             ),
//             onChanged: (value) => {count = int.parse(value)},
//           ),
//           ElevatedButton(
//               onPressed: () async {
//                 print(number);
//                 print(status);
//                 print(address);
//                 print(count);
//                 numberEdit.clear();
//                 statusEdit.clear();
//                 addressEdit.clear();
//                 countEdit.clear();
//
//                 // viewModel.addParking(Symptom(
//                 //     number: number,
//                 //     address: address,
//                 //     status: status,
//                 //     count: count));
//               },
//               child: const Text("Save")),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             BorrowedBooks(viewModel: viewModel)));
//               },
//               child: const Text("See my books"))
//         ],
//       ),
//     );
//   }
// }

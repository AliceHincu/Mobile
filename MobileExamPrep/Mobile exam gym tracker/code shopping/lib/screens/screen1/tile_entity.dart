import 'package:code_shopping/models/my_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';

class Tile extends StatelessWidget {
  final MyEntity entity;
  final VoidCallback onTap;

  const Tile({Key? key, required this.entity, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        minVerticalPadding: 7,
        dense: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: AppColors.primaryColor.withOpacity(0.25),
        title: Text(
          entity.name ?? "",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "  description: ${entity.description}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "  category : ${entity.category}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              entity.date != null ? "  date : ${DateFormat('yyyy-MM-dd').format(DateTime.parse(entity.date!))}" : "",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "  time : ${entity.time}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "  intensity : ${entity.intensity}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
            ),
          ],
        ),
        // onTap: () => showDialog(
        //     context: context,
        //     builder: (context) => Center(
        //       child: Stack(children: [
        //         SingleChildScrollView(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Flexible(
        //                       child: Image.asset('assets/images/img.png')),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: [
        //             Material(
        //               color: Colors.black.withOpacity(0.5),
        //               child: IconButton(
        //                 onPressed: () => Navigator.of(context).pop(),
        //                 icon: const Icon(
        //                   Icons.close,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         )
        //       ]),
        //     )),
      ),
    );
  }
}

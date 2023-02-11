import 'package:code_shopping/models/symptom.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class Tile extends StatelessWidget {
  final Symptom entity;
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
          entity.symptom ?? "",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "  date: ${entity.date}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "  medication : ${entity.medication}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "  dosage : ${entity.dosage}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "  doctor : ${entity.doctor}",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              "  notes : ${entity.notes}",
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

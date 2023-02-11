import 'package:code_shopping/models/my_entity.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class TileProgress extends StatelessWidget {
  final String monthName;
  final int count;

  const TileProgress({Key? key, required this.monthName, required this.count})
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
          monthName ?? "",
          style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          "  $count",
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

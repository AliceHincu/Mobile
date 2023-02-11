import 'dart:io';

import 'package:code_shopping/repo/repo.dart';


class Utils {

  static Future<bool> get checkInternetConnection async {
    try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Repo.hasInternet = true;

        while(Repo.queue.isNotEmpty) {
          Repo().addEntity(Repo.queue.first);
          Repo.queue.removeFirst();
        }
        while(Repo.deleteQueue.isNotEmpty) {
          Repo().deleteEntity(Repo.deleteQueue.first);
          Repo.deleteQueue.removeFirst();
        }
        return true;
      }
      Repo.hasInternet = false;
      return false;
    } on SocketException catch (_) {
      Repo.hasInternet = false;
      return false;
    }
  }
}

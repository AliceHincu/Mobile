import 'package:code_shopping/repo/repo.dart';
import 'package:code_shopping/screens/screen3/report_view_model.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void setupLocator() {
  serviceLocator.registerLazySingleton<Repo>(() => Repo());
  //todo
  // serviceLocator.registerLazySingleton<ReportVM>(() => ReportViewModel(serviceLocator<Repo>()));
}

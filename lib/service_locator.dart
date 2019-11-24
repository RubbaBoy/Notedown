import 'package:notedown/scoped_model/error_model.dart';
import 'package:notedown/scoped_model/home_model.dart';
import 'package:notedown/scoped_model/success_model.dart';
import 'package:notedown/services/storage_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  // Register services
  locator.registerLazySingleton<RequestService>(() => RequestService());

  // Register models
  locator.registerFactory<HomeModel>(() => HomeModel());
  locator.registerFactory<ErrorModel>(() => ErrorModel());
  locator.registerFactory<SuccessModel>(() => SuccessModel());
}
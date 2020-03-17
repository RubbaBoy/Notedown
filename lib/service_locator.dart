import 'package:get_it/get_it.dart';

import 'package:notedown/scoped_model/category_edit_model.dart';
import 'package:notedown/scoped_model/error_model.dart';
import 'package:notedown/scoped_model/login_model.dart';
import 'package:notedown/scoped_model/note_edit_model.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/services/authentication_service.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/services/navigation_service.dart';
import 'package:notedown/services/request_service.dart';

GetIt locator = GetIt();

void setupLocator() {
  // Register services
  locator.registerLazySingleton<RequestService>(() => RequestService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<FunctionsService>(() => FunctionsService());
  locator.registerLazySingleton<AuthService>(() => AuthService());

  // Register models
  locator.registerFactory<NoteListModel>(() => NoteListModel());
  locator.registerFactory<NoteEditModel>(() => NoteEditModel());
  locator.registerFactory<ErrorModel>(() => ErrorModel());
  locator.registerFactory<LoginModel>(() => LoginModel());
  locator.registerFactory<CategoryEditModel>(() => CategoryEditModel());
}

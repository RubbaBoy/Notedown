import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/services/storage_service.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginModel extends BaseModel {
  FunctionsService functionsService = locator<FunctionsService>();
}

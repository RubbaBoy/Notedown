import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/request_service.dart';

class ErrorModel extends BaseModel {
  RequestService storageService = locator<RequestService>();
}
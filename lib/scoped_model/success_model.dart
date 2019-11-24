import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/storage_service.dart';
import 'package:scoped_model/scoped_model.dart';

class SuccessModel extends BaseModel {
  String title = "no text yet";

  Future fetchDuplicatedText(String text) async {
    setState(ViewState.Busy);
    await Future.delayed(Duration(seconds: 2));
    title = '$text $text';

    setState(ViewState.Retrieved);
  }
}

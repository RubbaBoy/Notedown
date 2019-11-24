import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/storage_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class HomeModel extends BaseModel {
  StorageService storageService = locator<StorageService>();

  String title = "HomeModel";

  Future<bool> saveData() async {
    setState(ViewState.Busy);
    title = "Fetching data";
    await storageService.saveData();

    var response = (await http.get('https://www.random.org/strings/?num=1&len=10&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new')).body;
    print('Response: $response');

    title = response;

    setState(ViewState.Retrieved);

    return true;
  }

}

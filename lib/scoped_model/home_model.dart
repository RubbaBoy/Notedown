import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/storage_service.dart';

class HomeModel extends BaseModel {
  RequestService storageService = locator<RequestService>();
  List<NoteData> notes = [];

  Future<List<NoteData>> getNotes() async {
    setState(ViewState.Busy);

    print('Notes size: ${notes.length}');

    notes = await storageService.getCachedNotes();

    print('New size: ${notes.length}');

    setState(ViewState.Retrieved);

    return notes;
  }
}

class NoteData {
  String title;
  String data;

  NoteData({this.title, this.data});
}

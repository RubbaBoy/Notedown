import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/ui/views/note_list_view.dart';
import 'package:http/http.dart' as http;

class RequestService {

  Map<String, List<NoteData>> notes = {};

  Future<List<NoteData>> _fetchNotes(String uuid) async {
    var response = (await http.get('https://www.random.org/strings/?num=10&len=10&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new')).body;
    print('Response: $response');
    return response.trim().split('\n').map((rand) => NoteData(title: 'Title $rand', preview: '$rand $uuid' * 3)).toList();
  }

  /// This is separated from the NoteCategory built-in list, as this stores no
  /// GUI pieces, and it allows for more controlled caching server-side from
  /// this class in the future.
  Future<List<NoteData>> getCachedNotes(NoteCategory category) async {
    var uuid = category.uuid;
    if (notes.containsKey(uuid)) return notes[uuid];
    return (notes[uuid] = await _fetchNotes(uuid));
  }
}

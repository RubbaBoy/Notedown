import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/ui/views/note_list_view.dart';
import 'package:http/http.dart' as http;

class RequestService {

  Map<int, List<NoteData>> notes = {};

  Future<List<NoteData>> _fetchNotes(int id) async {
    var response = (await http.get('https://www.random.org/strings/?num=10&len=10&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new')).body;
    print('Response: $response');
    return response.trim().split('\n').map((rand) => NoteData(title: rand, data: '$rand $id $rand $id $rand $id $rand $id $rand')).toList();
  }

  /// This is separated from the NoteCategory built-in list, as this stores no
  /// GUI pieces, and it allows for more controlled caching server-side from
  /// this class in the future.
  Future<List<NoteData>> getCachedNotes(NoteCategory category) async {
    var id = category.id;
    if (notes.containsKey(id)) return notes[id];
    return (notes[id] = await _fetchNotes(id));
  }
}

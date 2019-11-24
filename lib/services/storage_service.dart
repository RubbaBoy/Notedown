import 'package:notedown/scoped_model/home_model.dart';
import 'package:notedown/ui/views/home_view.dart';
import 'package:http/http.dart' as http;

class RequestService {

  List<NoteData> notes;

  Future<List<NoteData>> fetchNotes() async {
    var response = (await http.get('https://www.random.org/strings/?num=10&len=10&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new')).body;
    print('Response: $response');
    return notes = response.split('\n').map((rand) => NoteData(title: rand, data: '$rand $rand $rand $rand $rand')).toList();
  }

  Future<List<NoteData>> getCachedNotes() async => notes ?? fetchNotes();
}

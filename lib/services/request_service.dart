import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';

class RequestService {
  FunctionsService functionsService = locator<FunctionsService>();

  Map<String, List<FetchedNote>> notes = {};

  /// Fetches notes with the given category UUID
  Future<List<FetchedNote>> _fetchNotes(String categoryId) async =>
      await functionsService
          .getNotes(categoryId == NoteCategory.allUuid ? null : categoryId);

  /// This is separated from the NoteCategory built-in list, as this stores no
  /// GUI pieces, and it allows for more controlled caching server-side from
  /// this class in the future.
  Future<List<FetchedNote>> getCachedNotes(NoteCategory category) async {
    var uuid = category.uuid;
    if (notes.containsKey(uuid)) return notes[uuid];
    return (notes[uuid] = await _fetchNotes(uuid));
  }
}

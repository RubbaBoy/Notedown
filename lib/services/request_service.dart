import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';

class RequestService {
  FunctionsService functionsService = locator<FunctionsService>();

  Map<String, NoteStore> noteStores = {};

  /// Fetches notes with the given category UUID
  Future<NoteStore> _fetchNotes(String categoryId) async {
    return NoteStore(categoryId)
      ..networkFetched = true
      ..isAll = categoryId == NoteCategory.allUuid
      ..notes = await functionsService
          .getNotes(categoryId == NoteCategory.allUuid ? null : categoryId);
  }

  NoteStore getFromAll(String categoryId) => NoteStore(categoryId)
    ..networkFetched = true
    ..notes = noteStores[NoteCategory.allUuid]
        .notes
        .where((note) => note.category == categoryId)
        .toList();

  NoteStore getStore(String categoryId) =>
      noteStores[categoryId] ??= NoteStore(categoryId);

  /// This is separated from the NoteCategory built-in list, as this stores no
  /// GUI pieces, and it allows for more controlled caching server-side from
  /// this class in the future.
  Future<NoteStore> getCachedNotes(NoteCategory category) async {
    var uuid = category.uuid;
    if (!noteStores.containsKey(uuid)) noteStores[uuid] = NoteStore(uuid);
    var noteStore = noteStores[uuid];
    if (noteStore.networkFetched) return noteStore;
    if (noteStores.containsKey(NoteCategory.allUuid)) {
      if (noteStores[NoteCategory.allUuid].networkFetched) {
        return noteStores[uuid] = getFromAll(uuid);
      }
    }
    return noteStores[uuid] = await _fetchNotes(uuid);
  }

  void addNote(FetchedNote fetchedNote) {
    getStore(fetchedNote.category).notes.add(fetchedNote);
    getStore(NoteCategory.allUuid).notes.add(fetchedNote);
  }
}

class NoteStore {
  String id;
  bool networkFetched = false;
  bool isAll = false;
  List<FetchedNote> notes = [];

  NoteStore(this.id);
}

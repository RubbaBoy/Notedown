import 'package:notedown/scoped_model/note_list_model.dart';

class NavigationService {

  int selectedTab;
  List<NoteCategory> categories;

  Future<List<NoteCategory>> fetchCategories() async {
    return categories = [
      NoteCategory.all,
      NoteCategory(id: 1, name: 'Wish List'),
      NoteCategory(id: 2, name: 'Ideas'),
      NoteCategory(id: 3, name: 'Other Shit')
    ];
  }

  Future<List<NoteCategory>> getCachedCategories() async => categories ?? (categories = await fetchCategories());
}


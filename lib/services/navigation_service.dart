import 'package:notedown/scoped_model/note_list_model.dart';

class NavigationService {

  int selectedTab = 0;
  List<NoteCategory> categories;

  Future<List<NoteCategory>> fetchCategories() async {
    return categories = [
      NoteCategory.all,
      NoteCategory(uuid: 'c83a56bb-778c-4749-b166-bbfde05facd3', index: 1, name: 'Wish List'),
      NoteCategory(uuid: '583fc685-3e4c-4230-8027-4ec3338173e3', index: 2, name: 'Ideas'),
      NoteCategory(uuid: '563cfb52-4c36-4d93-a735-a7f6ea47dee4', index: 3, name: 'Other Shit')
    ];
  }

  Future<List<NoteCategory>> getCachedCategories() async => categories ?? (categories = await fetchCategories());
}

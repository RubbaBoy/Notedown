import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';

class NavigationService {
  FunctionsService functionsService = locator<FunctionsService>();

  int index = 1;
  int selectedTab = 0;
  List<NoteCategory> categories;

  Future<List<NoteCategory>> fetchCategories() async {
    print('Fetching categories!');

    var categories = await functionsService.getCategories();
    print('Found ${categories.length} categories');
    index = 1;
    return [NoteCategory.all, ...categories.map<NoteCategory>((fetched) => NoteCategory(uuid: fetched.id, index: index++, name: fetched.name)).toList()];
  }

  Future<List<NoteCategory>> getCachedCategories() async => categories ?? (categories = await fetchCategories());

  int nextIndex() => index++;
}

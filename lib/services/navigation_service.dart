import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/ui/views/note_list_view.dart';

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
    return [
      NoteCategory.all,
      ...categories
          .map<NoteCategory>((fetched) => NoteCategory(
              uuid: fetched.id, index: index++, name: fetched.name))
          .toList()
    ];
  }

  Future<List<NoteCategory>> getCachedCategories() async =>
      categories ?? (categories = await fetchCategories());

  void removeCategory(NoteCategory noteCategory) =>
      categories.remove(noteCategory);

  int nextIndex() => index++;

  static void toCategory(BuildContext context, NoteCategory category) {
    Navigator.push(context, NavigationService.getRouteOf(category));
  }

  static MaterialPageRoute getRouteOf(NoteCategory category) =>
      MaterialPageRoute(
        builder: (context) => NoteListView(category),
        settings: RouteSettings(name: category.uuid),
      );
}

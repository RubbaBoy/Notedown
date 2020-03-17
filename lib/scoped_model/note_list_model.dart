import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/services/navigation_service.dart';
import 'package:notedown/services/request_service.dart';
import 'package:notedown/ui/views/note_edit_view.dart';
import 'package:notedown/ui/views/note_list_view.dart';

class NoteListModel extends BaseModel {
  RequestService _requestService = locator<RequestService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<NoteDisplay> notes = [];

  int get selectedTab => navigationService.selectedTab;

  set selectedTab(value) => navigationService.selectedTab = value;

  void refreshNotes(BuildContext context, NoteCategory category) {
    print('Loading notes for ${category.name}...');
    if (category.removed) {
      print('Note has been removed!');
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NoteListView(NoteCategory.all),
              settings: RouteSettings(name: category.uuid)));
      return;
    }

    _requestService.getCachedNotes(category).then((cached) {
      category.notes = cached.notes
          .map((data) => NoteDisplay(note: data, model: this))
          .toList();
      notifyListeners();
    });
  }

  void openNote(BuildContext context,
      {String categoryId = '', FetchedNote note, Function(FetchedNote) save}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteEditView(
                note: note ?? FetchedNote('', categoryId, '', ''),
                save: save)));
  }

  void addNote(NoteCategory category, FetchedNote note) {
    print('addNote() note cat: ${note.category}');
    _requestService.addNote(note);
    category.notes.add(NoteDisplay(note: note, model: this));
    notifyListeners();
  }
}

enum CategoryType { All, Named }

class NoteCategory {
  static const String allUuid = 'b70b1f26-f2a9-4553-8271-81442538520d';
  static NoteCategory all = NoteCategory(
      uuid: allUuid, index: 0, name: 'All', type: CategoryType.All);

  List<NoteDisplay> notes = [];
  String uuid;
  String name;
  int index;
  CategoryType type;
  bool removed = false;

  NoteCategory(
      {this.uuid, this.index, this.name, this.type = CategoryType.Named})
      : assert(!(uuid == allUuid && type != CategoryType.All),
            'ID is 0 and category type is all');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteCategory &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}

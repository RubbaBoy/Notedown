import 'package:flutter/material.dart';
import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/storage_service.dart';
import 'package:notedown/ui/views/note_list_view.dart';

class NoteListModel extends BaseModel {
  RequestService _requestService = locator<RequestService>();
  List<NoteDisplay> notes = [];

  int get selectedTab => navigationService.selectedTab;

  set selectedTab(value) => navigationService.selectedTab = value;

  Future refreshNotes(NoteCategory category) async {
    print('Loading notes for ${category.name}...');
    setState(ViewState.Busy);

    // TODO: Make #getCachedNotes() request category-specific notes
    var cached = await _requestService.getCachedNotes(category);
    category.notes = cached.map((data) => NoteDisplay(text: data.data))
        .toList();

    print('DONE loading notes for ${category.name} Notes: ${category.notes}');

    setState(ViewState.Retrieved);
  }
}

class NoteData {
  String title;
  String data;

  NoteData({this.title, this.data});
}

enum CategoryType {
  All, Named
}

class NoteCategory {
  static NoteCategory all = NoteCategory(id: 0, name: 'All', type: CategoryType.All);

  List<NoteDisplay> notes = [];
  int id;
  String name;
  CategoryType type;

  NoteCategory({this.id, this.name, this.type = CategoryType.Named}) : assert(!(id == 0 && type != CategoryType.All), 'ID is 0 and category type is all');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NoteCategory &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

}

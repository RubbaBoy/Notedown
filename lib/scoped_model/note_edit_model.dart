import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';

class NoteEditModel extends BaseModel {
  FunctionsService functionsService = locator<FunctionsService>();
  KeyboardVisibilityNotification keyboardVisibilityNotification = KeyboardVisibilityNotification();
  FocusNode titleFocusNode = FocusNode();
  FocusNode bodyFocusNode = FocusNode();
  bool editingTitle = false;
  TextEditingController _titleController;
  TextEditingController _contentController;

  FetchedNote _note;

  String title;

  void tapTitle(BuildContext context) {
    editingTitle = true;
    notifyListeners();

    Future.delayed(Duration(milliseconds: 100), () => FocusScope.of(context).requestFocus(titleFocusNode));
  }

  void tapBody() {
    if (editingTitle) {
      editingTitle = false;
      notifyListeners();
    }
  }

  void reset(BuildContext context, TextEditingController titleController, TextEditingController contentController, FetchedNote note) {
    _titleController = titleController;
    _contentController = contentController;
    _note = note;
    title = _note.title;

    keyboardVisibilityNotification.addNewListener(
      onChange: (visible) {
        if (!visible) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (currentFocus.focusedChild == titleFocusNode) {
            submitTitle(_titleController.text);
          }
          currentFocus.unfocus();
        }
      },
    );
  }

  void dispose(Function() saved) {
    keyboardVisibilityNotification.dispose();
    if (save()) {
      saved();
    }
  }

  bool save() {
    var oldContent = _note.content?.trim();
    var newContent = _contentController.text.trim();

    var oldTitle = _note.title?.trim();
    var newTitle = title.trim();

    if (oldContent != newContent || oldTitle != newTitle) {
      print('Saving...');

      _note.content = newContent;
      _note.title = newTitle;
      functionsService.editNote(id: _note.id, categoryId: _note.category, title: newTitle, content: newContent);
      return true;
    }

    return false;
  }

  void titleChanged(String title) {
    this.title = title;
  }

  void submitTitle(String title) {
    this.title = title;
    editingTitle = false;
    notifyListeners();
  }
}

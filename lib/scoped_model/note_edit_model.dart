import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/services/functions_service.dart';

class NoteEditModel extends BaseModel {
  KeyboardVisibilityNotification keyboardVisibilityNotification = KeyboardVisibilityNotification();
  FocusNode titleFocusNode = FocusNode();
  FocusNode bodyFocusNode = FocusNode();
  bool editingTitle = false;
  TextEditingController _titleController;

  FetchedNote _note;

  String get title => _note.title;
  String get content => _note.content;

  NoteEditModel() {
    print('New NoteEditModel!!!!!!!!!!!!!!');
  }

  void tapTitle(BuildContext context) {
    editingTitle = true;
    notifyListeners();

    Future.delayed(Duration(milliseconds: 100), () => FocusScope.of(context).requestFocus(titleFocusNode));
  }

  void reset(BuildContext context, TextEditingController titleController, FetchedNote note) {
    _titleController = titleController;
    _note = note;
    editingTitle = false;

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

  void dispose() {
    keyboardVisibilityNotification.dispose();
  }

  void submitTitle(String title) {
    print('Submitted "$title"');
    _note.title = title;
    editingTitle = false;
    notifyListeners();
  }
}
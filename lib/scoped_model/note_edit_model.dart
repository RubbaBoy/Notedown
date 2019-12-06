import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';

class NoteEditModel extends BaseModel {
  FunctionsService functionsService = locator<FunctionsService>();
  KeyboardVisibilityNotification keyboardVisibilityNotification =
      KeyboardVisibilityNotification();
  FocusNode titleFocusNode = FocusNode();
  FocusNode bodyFocusNode = FocusNode();
  bool editingTitle = false;
  bool editingContent = false;
  TextEditingController titleController;
  TextEditingController contentController;

  FetchedNote _note;

  String title;

  void tapTitle(BuildContext context) {
    editingTitle = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 100),
        () => FocusScope.of(context).requestFocus(titleFocusNode));
  }

  void tapBody() {
    if (editingTitle) {
      editingTitle = false;
      notifyListeners();
    }
  }

  void toggleEdit() {
    editingContent = !editingContent;
    editingTitle = false;
    notifyListeners();
  }

  void doubleTapHtml(BuildContext context) {
    contentController.selection =
        contentController.selection.copyWith(affinity: TextAffinity.downstream);
    editingContent = !editingContent;
    editingTitle = false;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 100),
        () => FocusScope.of(context).requestFocus(bodyFocusNode));
  }

  void reset(BuildContext context, TextEditingController titleController,
      TextEditingController contentController, FetchedNote note) {
    this.titleController = titleController;
    this.contentController = contentController;
    _note = note;
    title = _note.title;

    keyboardVisibilityNotification.addNewListener(
      onChange: (visible) {
        if (!visible) {
          final currentFocus = FocusScope.of(context);
          if (currentFocus.focusedChild == titleFocusNode) {
            submitTitle(this.titleController.text);
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
    final oldContent = _note.content?.trim();
    final newContent = contentController.text.trim();

    final oldTitle = _note.title?.trim();
    final newTitle = title.trim();

    if (oldContent != newContent || oldTitle != newTitle) {
      _note.content = newContent;
      _note.title = newTitle;
      functionsService.editNote(
          id: _note.id,
          categoryId: _note.category,
          title: newTitle,
          content: newContent);
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

enum Format { bold, italics, underline, quote, code, list }

extension FormatPress on Format {
  void press(NoteEditModel model) {
    final content = model.contentController;
    final text = content.text;
    final selection = content.selection;
    final multiChar = selection.start != selection.end;

    void surroundIn(String surround) {
      final middle =
          !multiChar ? '' : text.substring(selection.start, selection.end);
      content.text =
          '${text.substring(0, selection.start)}$surround$middle$surround${text.substring(selection.end)}';
      content.selection = content.selection.copyWith(
          baseOffset: selection.start + surround.length,
          extentOffset: selection.end + surround.length);
    }

    void prefixWith(String prefix) {
      final newline = max(
              -1,
              text.lastIndexOf(
                  RegExp(r'(\n|^)'), max(0, selection.start - 1))) +
          1;

      content.text =
          '${text.substring(0, newline - 1)}$prefix${text.substring(newline, text.length - 1)}';
      content.selection =
          content.selection.copyWith(baseOffset: newline + prefix.length);
    }

    void formatBold() => surroundIn('**');

    void formatItalics() => surroundIn('*');

    void formatUnderline() => surroundIn('__');

    void formatQuote() => prefixWith('\n> ');

    void formatCode() {
      final newline = max(
              -1,
              text.lastIndexOf(
                  RegExp(r'(\n|^)'), max(0, selection.start - 1))) +
          1;
      final end = max(-1, text.indexOf(RegExp(r'(\n|$)'), selection.end));

      final hasEnd = end < text.length - 1;
      final afterTick = hasEnd ? text.substring(end, text.length - 1) : '';
      content.text =
          '${text.substring(0, newline)}```\n${text.substring(newline, end)}\n```$afterTick';
      content.selection = content.selection
          .copyWith(baseOffset: newline, extentOffset: newline);
    }

    void formatList() => prefixWith('\n- ');

    return {
      Format.bold: formatBold,
      Format.italics: formatItalics,
      Format.underline: formatUnderline,
      Format.quote: formatQuote,
      Format.code: formatCode,
      Format.list: formatList,
    }[this]();
  }
}

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/services/navigation_service.dart';
import 'package:notedown/services/request_service.dart';

class CategoryEditModel extends BaseModel {
  final functionsService = locator<FunctionsService>();
  final navigationService = locator<NavigationService>();
  final requestService = locator<RequestService>();
  final uuid = Uuid();

  List<NoteCategory> fetchedCategories = [];

  Map<NoteCategory, FocusNode> categoryFocuses = {};
  Map<NoteCategory, TextEditingController> categoryControllers = {};
  NoteCategory inFocusCategory;
  bool topFocus = false;

  TextEditingController topController = TextEditingController();
  FocusNode topFocusNode = FocusNode();

  CategoryEditModel() {
    topFocusNode.addListener(() {
      if (topFocus = topFocusNode.hasFocus) {
        categoryFocuses[inFocusCategory]?.unfocus();
        inFocusCategory = null;
      }

      notifyListeners();
    });

    navigationService.getCachedCategories().then((categories) {
      fetchedCategories = categories;
      notifyListeners();
    });
  }

  Future<bool> handlePop(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context, NavigationService.getRouteOf(NoteCategory.all), (_) => false);
    navigationService.selectedTab = 0;
    return Future.value(false);
  }

  TextEditingController getController(NoteCategory category) =>
      categoryControllers[category] ??=
          TextEditingController(text: category.name);

  FocusNode addFocus(NoteCategory category) =>
      categoryFocuses[category] ??= _createFocus(category);

  bool showDivider(NoteCategory category) =>
      hasFocus(category) ||
      hasFocus(fetchedCategories[min(fetchedCategories.length - 1,
          fetchedCategories.indexOf(category) + 1)]);

  bool showTopDivider() =>
      topFocus ||
      hasFocus(fetchedCategories.isNotEmpty ? fetchedCategories.first : null);

  FocusNode _createFocus(NoteCategory category) {
    var focus = FocusNode();
    focus.addListener(() {
      if (focus.hasFocus) {
        if (inFocusCategory != null) {
          onSubmit(inFocusCategory);
        }

        inFocusCategory = category;
        notifyListeners();
        print('${category.uuid} is now in focus!');
      }
    });
    return focus;
  }

  void onSubmit(NoteCategory category) {
    var submitted = getController(category).text;
    print('Submitting for ID: ${category.uuid} = $submitted');
  }

  void onCheck(NoteCategory category) {
    categoryFocuses[inFocusCategory]?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    inFocusCategory = null;
    notifyListeners();
    onSubmit(category);
  }

  void onDelete(BuildContext context, NoteCategory category) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('${category.name} deleted'),
    ));

    categoryFocuses[inFocusCategory]?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    inFocusCategory = null;

    fetchedCategories.remove(category);
    categoryFocuses.remove(category);
    categoryControllers.remove(category);

    category.removed = true;
    functionsService.removeCategory(category.uuid);
    navigationService.removeCategory(category);

    notifyListeners();
  }

  bool hasFocus(NoteCategory category) => category == inFocusCategory;

  void createCategory() {
    var text = topController.text.trim();
    if (text.isNotEmpty) {
      fetchedCategories.add(NoteCategory(
          uuid: uuid.v4(), index: navigationService.nextIndex(), name: text));
    }

    endCreating();
  }

  void startCreating(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100),
        () => FocusScope.of(context).requestFocus(topFocusNode));
  }

  void endCreating() {
    topFocus = false;
    inFocusCategory = null;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    topFocusNode.unfocus();
    topController.clear();
    notifyListeners();
  }
}

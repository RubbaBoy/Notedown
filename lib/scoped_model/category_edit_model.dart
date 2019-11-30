import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/services/functions_service.dart';

class CategoryEditModel extends BaseModel {
  List<FetchedCategory> fetchedCategories = [
    FetchedCategory('111', 'One'),
    FetchedCategory('222', 'Two'),
    FetchedCategory('333', 'Three'),
    FetchedCategory('444', 'Four'),
    FetchedCategory('555', 'Five')
  ];
  Map<FetchedCategory, FocusNode> categoryFocuses = {};
  Map<FetchedCategory, TextEditingController> categoryControllers = {};
  FetchedCategory inFocusCategory;
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
  }

  TextEditingController getController(FetchedCategory category) =>
      categoryControllers[category] ??=
          TextEditingController(text: category.name);

  FocusNode addFocus(FetchedCategory category) =>
      categoryFocuses[category] ??= _createFocus(category);

  bool showDivider(FetchedCategory category) =>
      hasFocus(category) ||
      hasFocus(
          fetchedCategories[min(fetchedCategories.length - 1, fetchedCategories.indexOf(category) + 1)]);

  bool showTopDivider() => topFocus || hasFocus(fetchedCategories[0]);

  FocusNode _createFocus(FetchedCategory category) {
    var focus = FocusNode();
    focus.addListener(() {
      if (focus.hasFocus) {
        if (inFocusCategory != null) {
          onSubmit(inFocusCategory);
        }

        inFocusCategory = category;
        notifyListeners();
        print('${category.id} is now in focus!');
      }
    });
    return focus;
  }

  void onSubmit(FetchedCategory category) {
    var submitted = getController(category).text;
    print('Submitting for ID: ${category.id} = $submitted');
  }

  void onCheck(FetchedCategory category) {
    categoryFocuses[inFocusCategory]?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    inFocusCategory = null;
    notifyListeners();
    onSubmit(category);
  }

  void onDelete(BuildContext context, FetchedCategory category) {
    print('Deletinggg ${category.id}');

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("${category.name} deleted"),
    ));

    categoryFocuses[inFocusCategory]?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    inFocusCategory = null;

    fetchedCategories.remove(category);
    categoryFocuses.remove(category);
    categoryControllers.remove(category);
    notifyListeners();
  }

  bool hasFocus(FetchedCategory category) => category == inFocusCategory;

  var temp = 10;

  void createCategory() {
    var text = topController.text.trim();
    if (text.isNotEmpty) {
      print('Creating category: $text');
      fetchedCategories
          .add(FetchedCategory('${temp++}' * 3, text));
      print(fetchedCategories);
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

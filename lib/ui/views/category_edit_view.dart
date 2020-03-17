import 'dart:async';

import 'package:flutter/material.dart';

import 'package:notedown/scoped_model/category_edit_model.dart';
import 'package:notedown/ui/views/base_view.dart';

class CategoryEditView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CategoryEditViewState();
}

class CategoryEditViewState extends State<CategoryEditView> {
  TextStyle textStyle;
  TextStyle hintStyle;

  @override
  Widget build(BuildContext context) {
    textStyle = Theme.of(context).textTheme.body1.copyWith(fontSize: 18);
    hintStyle = textStyle.copyWith(
      fontSize: 18,
      color: textStyle.color.withAlpha(127),
    );
    return BaseView<CategoryEditModel>(
      showFab: false,
      onModelReady: (model) {},
      builder: (context, child, model) => WillPopScope(
        onWillPop: () => model.handlePop(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getLeftAction(
                  icon: Icons.arrow_back,
                  onPressed: () => model.handlePop(context),
                ),
                Text(
                  'Edit categories',
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            // This and the SizedBox is to essentially move the Divider up by 8px
            Divider(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (!model.topFocus)
                          getLeftAction(
                            icon: Icons.add,
                            onPressed: () => model.startCreating(context),
                          ),
                        if (model.topFocus)
                          getLeftAction(
                            icon: Icons.clear,
                            onPressed: () => model.endCreating(),
                          ),
                        Expanded(
                          child: TextField(
                            autofocus: false,
                            focusNode: model.topFocusNode,
                            controller: model.topController,
                            onSubmitted: (_) => model.createCategory(),
                            onEditingComplete: () => model.createCategory(),
                            textAlign: TextAlign.left,
                            style: textStyle,
                            decoration: InputDecoration(
                              hintStyle: hintStyle,
                              hintText: 'Create new category',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (model.topFocus)
                          getButton(
                            icon: Icons.check,
                            color: Colors.blue,
                            padding: EdgeInsets.fromLTRB(32, 16, 16, 16),
                            onPressed: () => model.createCategory(),
                          ),
                      ],
                    ),
                    getDivider(context, model.showTopDivider()),
                    ...getCategoryDisplays(context, model),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getCategoryDisplays(
          BuildContext context, CategoryEditModel model) =>
      model.fetchedCategories
          .map(
            (category) => Dismissible(
              key: Key(category.uuid),
              onDismissed: (_) => model.onDelete(context, category),
              confirmDismiss: (_) async => await confirmDelete(),
              background: Container(
                color: Colors.red,
                child: Row(
                  children: [
                    getLeftAction(
                      icon: Icons.warning,
                      onPressed: () {},
                    ),
                    Text('Delete'),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (!model.hasFocus(category))
                        getLeftAction(
                          icon: Icons.label_outline,
                          onPressed: () {},
                        ),
                      if (model.hasFocus(category))
                        getLeftAction(
                          icon: Icons.delete,
                          onPressed: () => confirmDelete().then(
                            (delete) {
                              if (delete) {
                                model.onDelete(context, category);
                              }
                            },
                          ),
                        ),
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          focusNode: model.addFocus(category),
                          controller: model.getController(category),
                          onSubmitted: (_) => model.onSubmit(category),
                          onEditingComplete: () => model.onSubmit(category),
                          textAlign: TextAlign.left,
                          style: textStyle,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (model.hasFocus(category))
                        getButton(
                          icon: Icons.check,
                          color: Colors.blue,
                          padding: EdgeInsets.fromLTRB(32, 16, 16, 16),
                          onPressed: () => model.onCheck(category),
                        ),
                    ],
                  ),
                  getDivider(context, model.showDivider(category)),
                ],
              ),
            ),
          )
          .toList();

  Future<dynamic> confirmDelete() async {
    var completer = Completer();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Delete this?'),
          content: Text(
              'Are you sure you want to delete this category? Its containing notes will not be deleted.'),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
            ),
            RaisedButton(
              child: Text('Delete'),
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(true);
              },
            ),
          ],
        );
      },
    );

    return completer.future;
  }

  Widget getDivider(BuildContext context, bool enabled) =>
      enabled ? Divider(height: 8) : SizedBox(height: 8);

  Widget getLeftAction(
          {@required IconData icon, Color color, Function() onPressed}) =>
      getButton(
          icon: icon,
          color: color,
          padding: EdgeInsets.fromLTRB(16, 16, 32, 16),
          onPressed: onPressed);

  Widget getButton(
      {@required IconData icon,
      Color color,
      double size = 24,
      double vpadding = 8,
      double hpadding = 8,
      EdgeInsets padding,
      Function() onPressed}) {
    double hTotal = hpadding * 2;
    double vTotal = vpadding * 2;
    if (padding != null) {
      hTotal = padding.left + padding.right;
      vTotal = padding.top + padding.bottom;
    }

    return SizedBox(
      width: size + hTotal,
      height: size + vTotal,
      child: IconButton(
        splashColor: ThemeData.dark().splashColor,
        icon: Icon(icon, size: size, color: color),
        onPressed: onPressed,
        padding: padding ??
            EdgeInsets.fromLTRB(
              hpadding,
              vpadding,
              hpadding,
              vpadding,
            ),
        alignment: AlignmentDirectional.center,
      ),
    );
  }
}

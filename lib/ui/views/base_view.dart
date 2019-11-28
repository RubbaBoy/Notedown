import 'package:flutter/material.dart';
import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/ui/views/note_list_view.dart';
import 'package:notedown/ui/widgets/busy_overlay.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final ScopedModelDescendantBuilder<T> _builder;
  final Function(T) onModelReady;

  BaseView(
      {GlobalKey<ScaffoldState> scaffoldKey,
      ScopedModelDescendantBuilder<T> builder,
      this.onModelReady})
      : _scaffoldKey = scaffoldKey,
        _builder = builder;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T _model = locator<T>();
  ScopedModelDescendantBuilder<T> otherBuilder;

  @override
  void initState() {
    otherBuilder = (context, child, model) => BusyOverlay(
          show: model.state == ViewState.Busy,
          child: Scaffold(
            key: widget._scaffoldKey,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                print('Add note!');
              },
            ),
            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text('Adam Yarris'),
                    accountEmail: Text('adam@yarr.is'),
                    currentAccountPicture: Container(
                        decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://rubbaboy.me/images/5hy10o9.png'),
                      ),
                    )),
                  ),
                  ...getCategoryTiles(context),
                  drawerSeparator(),
                  drawerItem(context, Icons.delete, 'Trash'),
                  drawerSeparator(),
                  drawerItem(context, Icons.settings, 'Settings'),
                ],
              ),
            ),
            body: SafeArea(
              child: widget._builder(context, child, model),
            ),
          ),
        );

    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }

    _model.navigationService.getCachedCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<T>(
        model: _model,
        child: ScopedModelDescendant<T>(
          child: Container(color: Colors.red),
          builder: otherBuilder,
        ));
  }

  List<ListTile> getCategoryTiles(BuildContext context) =>
      _model.navigationService.categories
          ?.map((category) => drawerItem(
              context,
              category.type == CategoryType.Named
                  ? Icons.label_outline
                  : Icons.home,
              category.name,
              id: category.index,
              builder: (context) => NoteListView(category: category)))
          ?.toList() ??
      [];

  Divider drawerSeparator() => Divider();

  ListTile drawerSectionTitle(BuildContext context, String name) => ListTile(
        isThreeLine: false,
        dense: true,
        title: Text(
          name,
          style: Theme.of(context).textTheme.subtitle,
        ),
      );

  ListTile drawerItem(BuildContext context, IconData icon, String name,
      {bool selected = false, int id = -1, Function() onTap, WidgetBuilder builder}) {
    return ListTile(
        leading: Icon(icon),
        title: Text(name),
        selected: _model.navigationService.selectedTab == id,
        onTap: () {
          Navigator.pop(context);
          if (onTap != null) {
            onTap();
          } else if (builder != null) {
            Navigator.push(context, MaterialPageRoute(builder: builder));
            _model.navigationService.selectedTab = id;
          }
        });
  }
}

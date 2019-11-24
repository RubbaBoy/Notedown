import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/home_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/ui/views/base_view.dart';
import 'package:notedown/ui/views/error_view.dart';
import 'package:notedown/ui/views/success_view.dart';
import 'package:notedown/ui/widgets/busy_overlay.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NoteWrapState> _noteWrapKey = GlobalKey<NoteWrapState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
        builder: (context, child, model) =>
            BusyOverlay(
              show: model.state == ViewState.Busy,
              child: Scaffold(
                key: _scaffoldKey,
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
                      drawerItem(context, Icons.lightbulb_outline, 'All', () {}),
                      drawerSectionTitle(context, 'Categories'),
                      drawerItem(context, Icons.label_outline, 'Wish List', () {}),
                      drawerItem(context, Icons.label_outline, 'Ideas', () {}),
                      drawerItem(context, Icons.label_outline, 'Other Shit', () {}),
                      drawerSeparator(),
                      drawerItem(context, Icons.delete, 'Trash', () {}),
                      drawerSeparator(),
                      drawerItem(context, Icons.settings, 'Settings', () {}),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Container(
                          color: Theme
                              .of(context)
                              .cardColor,
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.menu),
                                onPressed: () =>
                                    _scaffoldKey.currentState.openDrawer(),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search notes',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(OMIcons.viewAgenda),
                                onPressed: () {
                                  print('Changed view type!');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      NoteWrap(
                        key: _noteWrapKey,
                        children: [
                          display(),
                          display(),
                          display(),
                          display(),
                          display(),
                          display(),
                          display(),
                          display(),
                          display(),
                          display()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Divider drawerSeparator() {
    return Divider();
  }

  ListTile drawerSectionTitle(BuildContext context, String name) {
    return ListTile(
      isThreeLine: false,
      dense: true,
      title: Text(
          name,
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }

  ListTile drawerItem(BuildContext context, IconData icon, String name, Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        onTap();
      }
    );
  }

  NoteDisplay display() => NoteDisplay(_noteWrapKey);
}

class NoteDisplay extends StatefulWidget {
  final GlobalKey<NoteWrapState> _noteWrapKey;

  NoteDisplay(this._noteWrapKey);

  @override
  State<StatefulWidget> createState() => NoteState(_noteWrapKey);
}

class NoteState extends State<NoteDisplay> {
  final GlobalKey<NoteWrapState> _noteWrapKey;

  NoteState(this._noteWrapKey);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(_noteWrapKey.currentState.childrenMargin),
        child: Container(
            height: (Random.secure().nextDouble() * 200 + 50) as double,
            child: Text('Text from some random ass note that is right here.')));
  }
}

class NoteWrap extends StatefulWidget {
  final List<NoteDisplay> children;

  NoteWrap({Key key, this.children}) : super(key: key);

  @override
  State createState() => NoteWrapState(children: children);
}

class NoteWrapState extends State<NoteWrap> {
  final List<NoteDisplay> children;
  double childrenWidth = 1;
  double childrenMargin = 5;

  NoteWrapState({this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: CustomScrollView(
            slivers: [
              SliverStaggeredGrid.countBuilder(
                crossAxisCount: 2,
                staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                itemBuilder: (context, index) => children[index],
                itemCount: children.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

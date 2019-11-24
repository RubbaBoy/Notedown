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

final double childrenMargin = 5;

class HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NoteWrapState> _noteWrapKey = GlobalKey<NoteWrapState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
        onModelReady: (model) => model.getNotes(),
        builder: (context, child, model) => BusyOverlay(
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
                      drawerItem(context, Icons.home, 'All', () {},
                          selected: true),
                      drawerSectionTitle(context, 'Categories'),
                      drawerItem(
                          context, Icons.label_outline, 'Wish List', () {}),
                      drawerItem(context, Icons.label_outline, 'Ideas', () {}),
                      drawerItem(
                          context, Icons.label_outline, 'Other Shit', () {}),
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
                          color: Theme.of(context).cardColor,
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
                          children: model.notes
                              .map((data) => NoteDisplay(text: data.data))
                              .toList()),
                    ],
                  ),
                ),
              ),
            ));
  }

  Divider drawerSeparator() => Divider();

  ListTile drawerSectionTitle(BuildContext context, String name) => ListTile(
        isThreeLine: false,
        dense: true,
        title: Text(
          name,
          style: Theme.of(context).textTheme.subtitle,
        ),
      );

  ListTile drawerItem(
          BuildContext context, IconData icon, String name, Function() onTap,
          {bool selected = false}) =>
      ListTile(
          leading: Icon(icon),
          title: Text(name),
          selected: selected,
          onTap: () {
            Navigator.pop(context);
            onTap();
          });

  NoteDisplay display() => NoteDisplay();
}

class NoteDisplay extends StatefulWidget {
  final String text;

  NoteDisplay({this.text});

  @override
  State<StatefulWidget> createState() => NoteState(text: text);
}

class NoteState extends State<NoteDisplay> {
  final String text;

  NoteState({this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(childrenMargin),
        child: Container(
            height: (Random.secure().nextDouble() * 200 + 50),
            child: Text(text)));
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

  NoteWrapState({this.children});

  @override
  Widget build(BuildContext context) {
    print('Children size: ${children.length}');
    return Container(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: CustomScrollView(
            physics: null,
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

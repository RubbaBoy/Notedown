import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/ui/views/base_view.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

final double childrenMargin = 5;

class NoteListView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NoteCategory category;

  NoteListView({this.category});

  @override
  Widget build(BuildContext context) {
    return BaseView<NoteListModel>(
      scaffoldKey: _scaffoldKey,
      onModelReady: (model) async => await model.refreshNotes(category),
      builder: (context, child, model) => ListView(
        shrinkWrap: true,
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
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
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
          NoteWrap(noteCategory: category),
        ],
      ),
    );
  }
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
  final NoteCategory noteCategory;

  NoteWrap({Key key, this.noteCategory}) : super(key: key);

  @override
  State createState() => NoteWrapState(noteCategory: noteCategory);
}

class NoteWrapState extends State<NoteWrap> {
  final NoteCategory noteCategory;

  NoteWrapState({this.noteCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: CustomScrollView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverStaggeredGrid.countBuilder(
            crossAxisCount: 2,
            staggeredTileBuilder: (_) => StaggeredTile.fit(1),
            itemBuilder: (context, index) => noteCategory.notes[index],
            itemCount: noteCategory.notes.length,
          ),
        ],
      ),
    );
  }
}

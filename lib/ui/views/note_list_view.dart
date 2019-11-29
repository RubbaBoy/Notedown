import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/ui/views/base_view.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class NoteListView extends StatefulWidget {
  final NoteCategory category;

  NoteListView(this.category);

  @override
  State<StatefulWidget> createState() => NoteListViewState(category);
}

class NoteListViewState extends State<NoteListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NoteCategory category;

  NoteListViewState(this.category);

  @override
  Widget build(BuildContext context) {
    return BaseView<NoteListModel>(
      scaffoldKey: _scaffoldKey,
      onModelReady: (model) => model.refreshNotes(category),
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
  final NoteListModel model;
  final FetchedNote note;

  NoteDisplay({this.note, this.model});

  @override
  State<StatefulWidget> createState() => NoteState(note: note, model: model);
}

class NoteState extends State<NoteDisplay> {
  final NoteListModel model;
  final FetchedNote note;
  final String preview;

  NoteState({this.note, this.model})
      : preview = note.content.substring(0, min(note.content.length, 200));

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var titleTheme = textTheme.subhead.copyWith(fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () => model.openNote(context, note),
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  note.title,
                  style: titleTheme,
                ),
              ),
              Text(
                preview,
                style: Theme.of(context).textTheme.body1,
              ),
            ],
          ),
        ),
      ),
    );
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

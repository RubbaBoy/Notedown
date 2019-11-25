import 'package:flutter/material.dart';
import 'package:notedown/scoped_model/note_list_model.dart';

import 'base_view.dart';

class Template extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<NoteListModel>(
        builder: (context, child, model) => Scaffold(
          body: Center(child: Text(this.runtimeType.toString()),),
        ));
  }
}
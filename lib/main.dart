import 'package:flutter/material.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/ui/views/note_list_view.dart';

import 'service_locator.dart';

void main() {
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notedown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: NoteListView(category: NoteCategory.all),
    );
  }
}

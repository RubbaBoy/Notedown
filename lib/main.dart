import 'package:flutter/material.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/ui/views/note_edit_view.dart';

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
      // https://github.com/flutter/flutter/issues/35826#issuecomment-559239389
      theme: ThemeData.dark().copyWith(buttonTheme: ButtonThemeData(minWidth: 12), splashColor: Colors.transparent),
//      home: LoginView(),
      home: NoteEditView(FetchedNote('id-here', 'category-here', 'My Title', 'Some content is right here')),
    );
  }
}
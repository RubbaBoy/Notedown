import 'package:flutter/material.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/authentication_service.dart';
import 'package:notedown/services/navigation_service.dart';
import 'package:notedown/ui/views/category_edit_view.dart';

void main() {
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authService = locator<AuthService>();
  final navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notedown',
      debugShowCheckedModeBanner: false,
      // https://github.com/flutter/flutter/issues/35826#issuecomment-559239389
      theme: ThemeData.dark().copyWith(
          buttonTheme: ButtonThemeData(minWidth: 12),
          splashColor: Colors.transparent,
      ),
          home: Scaffold(body: CategoryEditView()),
//      home: FutureBuilder(
//        future: authService.trySilent().then((user) async {
//          if (user == null) return null;
//          await navigationService.getCachedCategories();
//          return user;
//        }),
//        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
//          switch (snapshot.connectionState) {
//            case ConnectionState.none:
//            case ConnectionState.waiting:
//              return Container(
//                  color: ThemeData.dark().scaffoldBackgroundColor,
//                  child: Center(child: CircularProgressIndicator()));
//            default:
//              if (snapshot.data == null) {
//                return LoginView();
//              } else {
//                return NoteListView(NoteCategory.all);
//              }
//          }
//        },
//      ),
    );
  }
}

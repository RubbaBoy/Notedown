import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/authentication_service.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/services/navigation_service.dart';
import 'package:notedown/ui/views/note_list_view.dart';

class LoginModel extends BaseModel {
  FunctionsService functionsService = locator<FunctionsService>();
  NavigationService navigationService = locator<NavigationService>();
  AuthService authService = locator<AuthService>();

  void _goToNotes(BuildContext context) {
    setState(ViewState.Busy);

    navigationService.getCachedCategories().then((_) {
      Navigator.pop(context);
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteListView(category: NoteCategory.all)));
      setState(ViewState.Retrieved);
    });
  }

  Future<void> checkAuthentication(BuildContext context) async {
    if (authService.isAuthenticated()) {
      _goToNotes(context);
    }
  }

  Future<void> onPress(BuildContext context) async {
    print('Logging in...');
    authService.signIn().then((user) async {
      print('${user.displayName} logged in');
      _goToNotes(context);
      Fluttertoast.showToast(msg: 'Welcome ${user.displayName}!');
    }).catchError((e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
      Fluttertoast.showToast(msg: 'An error occurred while authenticating!');
    });
  }
}

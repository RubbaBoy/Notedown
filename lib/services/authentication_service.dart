import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/services/navigation_service.dart';
import 'package:notedown/ui/views/note_list_view.dart';

class AuthService {
  final functionsService = locator<FunctionsService>();
  final navigationService = locator<NavigationService>();
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  FirebaseUser user;

  bool isAuthenticated() => user != null;

  FirebaseUser getUser() => user;

  Future<FirebaseUser> trySilent() async {
    return _googleSignIn.signInSilently().then((account) => firebaseFromGoogle(account));
  }

  Future<FirebaseUser> signIn() async {
    return _googleSignIn.signIn().then((account) => firebaseFromGoogle(account));
  }

  Future<FirebaseUser> firebaseFromGoogle(GoogleSignInAccount account) async {
    if (account == null) return null;
    final googleAuth = await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return user = (await _auth.signInWithCredential(credential)).user;
  }

  void goToNotes(BuildContext context) {
    navigationService.getCachedCategories().then((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoteListView(NoteCategory.all)));
    });
  }

  void checkAuthentication(BuildContext context) {
    if (isAuthenticated()) {
      goToNotes(context);
    } else {
      handleAuthed(context, trySilent());
    }
  }

  void handleAuthed(BuildContext context, Future<FirebaseUser> user) {
    if (user == null) return;
    user.then((user) {
      if (user == null) return;
      print('${user.displayName} logged in');
      goToNotes(context);
      Fluttertoast.showToast(msg: 'Welcome ${user.displayName}!');
    }).catchError((e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
      Fluttertoast.showToast(msg: 'An error occurred while authenticating!');
    });
  }
}

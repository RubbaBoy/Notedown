import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notedown/scoped_model/login_model.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/ui/views/base_view.dart';
import 'package:notedown/ui/views/empty_view.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

//import 'package:firebase_ui/flutter_firebase_ui.dart';
//import 'package:firebase_ui/l10n/localization.dart';

final double childrenMargin = 5;

class LoginView extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return EmptyView<LoginModel>(
//      onModelReady: (model) async => await model.refreshNotes(category),
      builder: (context, child, model) => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterLogo(size: 150),
          SizedBox(height: 50),
          RaisedButton(
            child: Text('Log in'),
            onPressed: () {
              print('Logging in!');

              _handleSignIn().then((FirebaseUser user) async {
                print(user);
                print('Hello ${user.displayName}!');

                var service = model.functionsService;
//                service.getCategories().then((categories) {
//                  print('Found ${categories.length} categories:');
//                  for (var cat in categories) {
//                    print('    ${cat.id} => ${cat.name}');
//                  }
//                }).catchError((e, s) {
//                  print('Exception details:\n $e');
//                  print('Stack trace:\n $s');
//                });

//              service.addCategory('Last Category').then((id) {
//                print('Wish List ID: $id');
//              }).catchError((e, s) {
//                print('Exception details:\n $e');
//                print('Stack trace:\n $s');
//              });

                service.editNote(id: '8ab31d88-7431-406f-85fd-86dcb7dbf1b1', category: '2c06f875-dd10-4d4a-9ea4-55af82daf8bb', title: 'My edited first note', content: 'This is the EDITED note\'s content!').then((id) {
                  print('Created note with the ID of $id');
                }).catchError((e, s) {
                  print('Exception details:\n $e');
                  print('Stack trace:\n $s');
                });

              }).catchError((e, s) {
                print('Exception details:\n $e');
                print('Stack trace:\n $s');
              });
            },
          ),
        ],
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}

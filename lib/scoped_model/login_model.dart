import 'package:flutter/material.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/authentication_service.dart';

class LoginModel extends BaseModel {
  final authService = locator<AuthService>();

  void onPress(BuildContext context) {
    print('Logging in...');
   authService.handleAuthed(context, authService.signIn());
  }
}

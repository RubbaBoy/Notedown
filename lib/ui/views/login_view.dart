import 'package:flutter/material.dart';
import 'package:notedown/scoped_model/login_model.dart';
import 'package:notedown/ui/views/empty_view.dart';

final double childrenMargin = 5;

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyView<LoginModel>(
      onModelReady: (model) async => await model.checkAuthentication(context),
      builder: (context, child, model) => Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              RaisedButton(
                child: Text('Log in'),
                onPressed: () async => await model.onPress(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

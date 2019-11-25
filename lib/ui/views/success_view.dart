import 'package:flutter/material.dart';
import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/scoped_model/success_model.dart';
import 'package:notedown/ui/widgets/busy_overlay.dart';

import 'base_view.dart';

class SuccessView extends StatelessWidget {
  final String title;

  SuccessView({this.title});

  @override
  Widget build(BuildContext context) {
    return BaseView<SuccessModel>(
      onModelReady: (model) => model.fetchDuplicatedText(title),
      builder: (context, child, model) => Container(
          child: Column(
        children: [
          getUI(model),
          Text(model.title),
        ],
      )),
    );
  }

  Widget getUI(SuccessModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return CircularProgressIndicator();
        break;
      default:
        return Text('Done!');
    }
  }
}

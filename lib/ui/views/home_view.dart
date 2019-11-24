import 'package:flutter/material.dart';
import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/home_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/ui/views/base_view.dart';
import 'package:notedown/ui/views/error_view.dart';
import 'package:notedown/ui/views/success_view.dart';
import 'package:notedown/ui/widgets/busy_overlay.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
        builder: (context, child, model) => BusyOverlay(
              show: model.state == ViewState.Busy,
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _getStateUi(model.state),
                      Text(model.title),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                                child: Text('Fetch data'),
                                onPressed: () async {
                                  print('Fetch pressed!');
                                  await model.saveData();
                                }),
                            SizedBox(width: 30),
                            RaisedButton(
                                child: Text('Switch!'),
                                onPressed: () {
                                  print('Switch pressed!');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SuccessView(title: 'Fetched data: ${model.title}')));
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget _getStateUi(ViewState state) {
    switch (state) {
      case ViewState.Busy:
//        return CircularProgressIndicator();
        return Text('-');
      case ViewState.Retrieved:
      default:
        return Text('Done');
    }
  }
}

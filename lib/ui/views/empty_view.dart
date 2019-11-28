import 'package:flutter/material.dart';
import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/base_model.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/ui/views/note_list_view.dart';
import 'package:notedown/ui/widgets/busy_overlay.dart';
import 'package:scoped_model/scoped_model.dart';

class EmptyView<T extends BaseModel> extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final ScopedModelDescendantBuilder<T> _builder;
  final Function(T) onModelReady;

  EmptyView({GlobalKey<ScaffoldState> scaffoldKey,
    ScopedModelDescendantBuilder<T> builder,
    this.onModelReady})
      : _scaffoldKey = scaffoldKey,
        _builder = builder;

  @override
  _EmptyViewState<T> createState() => _EmptyViewState<T>();
}

class _EmptyViewState<T extends BaseModel> extends State<EmptyView<T>> {
  T _model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }

    _model.navigationService.getCachedCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<T>(
        model: _model,
        child: ScopedModelDescendant<T>(
          child: Container(color: Colors.red),
          builder: widget._builder,
        ));
  }
}

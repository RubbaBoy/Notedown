import 'package:flutter/material.dart';
import 'package:notedown/scoped_model/note_edit_model.dart';
import 'package:notedown/services/functions_service.dart';
import 'package:notedown/ui/views/base_view.dart';

class NoteEditView extends StatefulWidget {
  final FetchedNote note;
  final Function(FetchedNote) save;

  NoteEditView({this.note, this.save});

  @override
  State<StatefulWidget> createState() => NoteEditViewState(note);
}

class NoteEditViewState extends State<NoteEditView> {
  TextEditingController titleController;
  TextEditingController contentController;
  FetchedNote note;

  NoteEditViewState(this.note);

  @override
  Widget build(BuildContext context) {
    return BaseView<NoteEditModel>(
      showFab: false,
      onModelReady: (model) {
        titleController = TextEditingController(text: note.title);
        contentController = TextEditingController(text: note.content);
        model.reset(context, titleController, contentController, note);
      },
      onModelEnd: (model) => model.dispose(() {
        if (widget.save != null) {
          widget.save(note);
        }
      }),
      builder: (context, child, model) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => model.tapTitle(context),
                  child: (!model.editingTitle
                      ? Text(
                          model.title,
                          style: Theme.of(context).textTheme.headline,
                          textAlign: TextAlign.center,
                        )
                      : TextField(
                          autofocus: true,
                          onSubmitted: model.submitTitle,
                          onChanged: model.titleChanged,
                          controller: titleController,
                          focusNode: model.titleFocusNode,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline,
                          decoration: InputDecoration(
                            hintStyle: Theme.of(context).textTheme.headline,
                            hintText: 'Title',
                            border: UnderlineInputBorder(),
                          ),
                        )),
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
          // This and the SizedBox is to essentially move the Divider up by 8px
          Divider(height: 8),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getFormatButton(
                icon: Icons.format_bold,
                onPressed: () => print('Bold'),
              ),
              getFormatButton(
                icon: Icons.format_italic,
                onPressed: () => print('Italics'),
              ),
              getFormatButton(
                icon: Icons.format_underlined,
                onPressed: () => print('Underline'),
              ),
              getFormatButton(
                icon: Icons.format_quote,
                onPressed: () => print('Quote'),
              ),
              getFormatButton(
                icon: Icons.code,
                onPressed: () => print('Code'),
              ),
              getFormatButton(
                icon: Icons.format_list_bulleted,
                onPressed: () => print('Bullet'),
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                maxLines: null,
                expands: true,
                maxLengthEnforced: false,
                enableInteractiveSelection: true,
                onTap: model.tapBody,
                controller: contentController,
                focusNode: model.bodyFocusNode,
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFormatButton({@required IconData icon, Function() onPressed}) =>
      getButton(
          icon: icon, size: 30, vpadding: 0, hpadding: 0, onPressed: onPressed);

  Widget getButton(
          {@required IconData icon,
          double size = 24,
          double vpadding = 8,
          double hpadding = 8,
          Function() onPressed}) =>
      SizedBox(
          width: size + hpadding * 2,
          height: size + vpadding * 2,
          child: IconButton(
            icon: Icon(icon, size: size),
            onPressed: onPressed,
            padding:
                EdgeInsets.fromLTRB(hpadding, vpadding, hpadding, vpadding),
            alignment: AlignmentDirectional.center,
          ));
}

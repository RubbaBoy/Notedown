import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as md;

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
                  child: !model.editingTitle
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
                        ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                icon: Icon(
                    model.editingContent ? Icons.remove_red_eye : Icons.edit),
                onPressed: model.toggleEdit,
              ),
            ],
          ),
          // This and the SizedBox is to essentially move the Divider up by 8px
          const Divider(height: 8),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getFormatButton(
                  model: model, icon: Icons.format_bold, format: Format.bold),
              getFormatButton(
                  model: model,
                  icon: Icons.format_italic,
                  format: Format.italics),
              getFormatButton(
                  model: model,
                  icon: Icons.format_underlined,
                  format: Format.underline),
              getFormatButton(
                  model: model, icon: Icons.format_quote, format: Format.quote),
              getFormatButton(
                  model: model, icon: Icons.code, format: Format.code),
              getFormatButton(
                  model: model,
                  icon: Icons.format_list_bulleted,
                  format: Format.list),
            ],
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                child: model.editingContent
                    ? TextField(
                        maxLines: null,
                        expands: true,
                        maxLengthEnforced: false,
                        enableInteractiveSelection: true,
                        onTap: model.tapBody,
                        keyboardType: TextInputType.multiline,
                        controller: contentController,
                        focusNode: model.bodyFocusNode,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 16),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Html(
                          data: md.markdownToHtml(contentController.text),
                        ),
                      ),
                onDoubleTap: () => model.doubleTapHtml(context),
                onTap: model.tapBody,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFormatButton(
          {@required IconData icon,
          @required NoteEditModel model,
          @required Format format}) =>
      getButton(
          icon: icon,
          size: 30,
          vpadding: 0,
          hpadding: 0,
          onPressed: () => format.press(model));

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

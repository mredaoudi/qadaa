import 'package:flutter/material.dart';

/// The `title` argument is used to title of alert dialog.
/// The `content` argument is used to content of alert dialog.
/// The `textOK` argument is used to text for 'OK' Button of alert dialog.
/// The `textCancel` argument is used to text for 'Cancel' Button of alert dialog.
///
/// Returns a [Future<bool>].
Future<bool> confirm(
  BuildContext context, {
  Widget? title,
  Widget? content,
  Color? backgroundColor,
  Widget? textOK,
  Widget? textCancel,
  Color? colorOK,
  Color? colorCancel,
}) async {
  final bool? isConfirm = await showDialog<bool>(
    context: context,
    builder: (_) => WillPopScope(
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: backgroundColor,
        elevation: 10,
        title: title,
        content: SingleChildScrollView(
          child: content ?? const Text('Are you sure continue?'),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(
                colorCancel,
              ),
            ),
            child: textCancel ??
                Text(MaterialLocalizations.of(context).cancelButtonLabel),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(
                colorOK,
              ),
            ),
            child:
                textOK ?? Text(MaterialLocalizations.of(context).okButtonLabel),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
    ),
  );

  return isConfirm ?? false;
}

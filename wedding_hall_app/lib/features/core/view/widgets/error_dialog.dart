import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import 'alert_error_dialog.dart';

Future<dynamic> errorDialog(
  BuildContext context, {
  String? title,
  String? buttonText,
  VoidCallback? onOk,
  required String message,
}) {
  return showDialog(
    context: context,
    builder: (context) => Center(
      child: BeautifulErrorDialog(
        message: message,
        title: title ?? S.of(context).errorHappened,
        buttonText: buttonText ?? S.of(context).ok,
        onOk: onOk,
      ),
    ),
  );
}

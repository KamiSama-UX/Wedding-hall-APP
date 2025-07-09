import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

void successDialog({
  required BuildContext context,
  required String successDialogMessage,
  VoidCallback? onDialogOk,
}) {
  AwesomeDialog(
    context: Navigator.of(context).overlay!.context,
    dialogType: DialogType.success,
    animType: AnimType.rightSlide,
    title: S.of(context).success,
    desc: successDialogMessage,
    btnOkOnPress: onDialogOk,
  ).show();
}

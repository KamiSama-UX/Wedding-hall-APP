import 'package:flutter/material.dart';

import '../../../../../config/theme/custom_text_style.dart';
import '../../../../../generated/l10n.dart';

class ViewAllButton extends StatelessWidget {
  final void Function() onPress;
  const ViewAllButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Text(
        S.of(context).viewAll,
        style: CustomTextStyle.font14PrimaryColorSemiBold,
      ),
    );
  }
}

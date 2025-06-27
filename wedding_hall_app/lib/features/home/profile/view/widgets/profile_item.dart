import 'package:flutter/material.dart';

import '../../../../../config/theme/custom_text_style.dart';

class ProfileItem extends StatelessWidget {
  final String itemTitle;
  final void Function() onItemTaped;
  final IconData itemIcon;
  const ProfileItem({
    super.key,
    required this.itemTitle,
    required this.onItemTaped,
    required this.itemIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onItemTaped,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              itemIcon,
            ),
            title: Text(
              itemTitle,
              style: CustomTextStyle.font16Blacklight,
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey.withValues(alpha: .1),
        )
      ],
    );
  }
}

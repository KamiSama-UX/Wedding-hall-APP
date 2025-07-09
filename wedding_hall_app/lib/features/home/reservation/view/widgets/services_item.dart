import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedding_hall_app/features/home/halls/data/models/hall_services_item.dart';

import '../../../../../config/theme/custom_text_style.dart';

class ServiceItem extends StatefulWidget {
  final HallServicesItem hallServiceItem;
  final int guestCount;
  const ServiceItem({
    super.key,
    required this.hallServiceItem,
    required this.guestCount,
  });

  @override
  State<ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.black.withValues(alpha: .5),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hallServiceItem.name,
            style: CustomTextStyle.font12BlackRegular,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Column(
            children: [
              Text(
                "${widget.hallServiceItem.servicePrice.toString()}\$",
                textAlign: TextAlign.end,
                style: CustomTextStyle.font12BlackRegular,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

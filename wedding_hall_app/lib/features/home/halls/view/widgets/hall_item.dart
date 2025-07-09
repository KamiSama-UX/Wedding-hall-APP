import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../../../config/networking/api_constants.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/custom_text_style.dart';
import '../../data/models/hall.dart';
import '../screens/hall_details_screen.dart';

class HallItem extends StatefulWidget {
  final Hall hall;
  const HallItem({super.key, required this.hall});

  @override
  State<HallItem> createState() => _HallItemState();
}

class _HallItemState extends State<HallItem> {
  late String coverImageUrl;
  @override
  void initState() {
    for (PhotoModel photoModel in widget.hall.photos) {
      if (photoModel.isCover) {
        coverImageUrl = photoModel.url;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HallDetailsScreen(hall: widget.hall),
              ),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: SizedBox(
                      height: 120.h,
                      width: 120.h,
                      child: CachedNetworkImage(
                        imageUrl:
                            widget.hall.photos.isNotEmpty
                                ? ApiConstants.baseUrl + coverImageUrl
                                : "",
                        placeholder:
                            (context, url) => Center(
                              child: SpinKitSpinningLines(
                                color: AppColors().primaryColor,
                                size: 40.0.r,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Center(
                              child: SvgPicture.asset("assets/svg/logo.svg"),
                            ),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.0.r),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hall.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyle.font14BlackSemiBold,
                        ),
                        Gap(4.h),
                        Text(
                          widget.hall.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: CustomTextStyle.font12BlackRegular,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

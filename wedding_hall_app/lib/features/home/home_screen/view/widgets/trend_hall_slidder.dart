import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';
import 'package:wedding_hall_app/config/networking/api_constants.dart';
import 'package:wedding_hall_app/config/routes/routes_path.dart';

import '../../../../../config/di/di.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/custom_text_style.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core/domain/base_classes/base_state.dart';
import '../../../../core/view/widgets/reusable_bloc_builder.dart';
import '../../../halls/data/models/hall.dart';
import '../../../halls/view/cubit/trend_hall_cubit.dart';
import 'shimmers/hot_offer_shimmer.dart';

class TrendHallSlidder extends StatefulWidget {
  final double carouselImageHeight;
  const TrendHallSlidder({super.key, required this.carouselImageHeight});

  @override
  State<TrendHallSlidder> createState() => _HotOrfferSlidderState();
}

class _HotOrfferSlidderState extends State<TrendHallSlidder> {
  final ValueNotifier<int> _indicatorIndexNotifier = ValueNotifier<int>(0);

  CarouselSliderController carouselSliderController =
      CarouselSliderController();
  int indicatorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ReusableBlocBuilder<TrendHallCubit>(
      createCubit: () => getIt<TrendHallCubit>(),
      shimmerBuilder:
          () =>
              TrendHallShimmer(carouselImageHeight: widget.carouselImageHeight),
      onBuild: (cubit) {
        cubit.emitTrendHall();
      },
      builder: (context, state) {
        if (state is SuccessState) {
          final topHalls = state.data as List<Hall>;
          List<String> coversImages = [];
          for (Hall hall in topHalls) {
            for (PhotoModel photoModel in hall.photos) {
              if (photoModel.isCover) {
                coversImages.add(ApiConstants.baseUrl + photoModel.url);
              }
            }
          }
          return ConditionalBuilder(
            condition: topHalls.isNotEmpty,
            builder: (context) {
              return Stack(
                children: [
                  CarouselSlider(
                    carouselController: carouselSliderController,
                    options: CarouselOptions(
                      height: widget.carouselImageHeight,
                      initialPage: 0,
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        _indicatorIndexNotifier.value = index;
                      },
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                    ),
                    items:
                        topHalls.map((value) {
                          String image = "";
                          for (PhotoModel ph in value.photos) {
                            if (coversImages.contains(ph.url)) {
                              image = ph.url;
                            }
                          }
                          print(image); 
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                RoutesPath.hallDetails,
                                arguments: value,
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: image,
                              placeholder:
                                  (context, url) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.grey[100]!,
                                    ),
                                    child: Center(
                                      child: SpinKitSpinningLines(
                                        color: AppColors().primaryColor,
                                        size: 40.0.r,
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) =>
                                      SvgPicture.asset("assets/svg/logo.svg"),
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(
                    height: widget.carouselImageHeight,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ValueListenableBuilder<int>(
                            valueListenable: _indicatorIndexNotifier,
                            builder: (context, index, child) {
                              return AnimatedSmoothIndicator(
                                activeIndex: index,
                                count: topHalls.length,
                                effect: ExpandingDotsEffect(
                                  activeDotColor: AppColors().primaryColor,
                                  expansionFactor: 5,
                                  dotWidth: 5.0.w,
                                  dotHeight: 5.0.h,
                                  spacing: 3.0.w,
                                ),
                              );
                            },
                          ),
                          Gap(10.0.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            fallback:
                (context) => Text(
                  S.of(context).thereIsNoHotOfferRightNow,
                  style: CustomTextStyle.font16BlackRegular,
                ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';
import 'package:wedding_hall_app/config/networking/api_constants.dart';
import 'package:wedding_hall_app/features/core/domain/base_classes/base_state.dart';
import 'package:wedding_hall_app/features/core/view/widgets/error_dialog.dart';
import 'package:wedding_hall_app/features/core/view/widgets/loading_dialog.dart';
import '../../../../../config/di/di.dart';
import '../../../../../config/routes/routes_path.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/custom_text_style.dart';
import '../../../../../generated/l10n.dart';
import '../../data/models/hall.dart';
import '../../domain/entity/hall_services_availability.dart';
import '../cubit/hall_services_availability_cubit.dart';
import '../cubit/halls_cubit.dart';

class HallDetailsScreen extends StatefulWidget {
  final Hall hall;
  const HallDetailsScreen({super.key, required this.hall});

  @override
  State<HallDetailsScreen> createState() => _HallDetailsScreenState();
}

class _HallDetailsScreenState extends State<HallDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _fabVisible = true;
  final ValueNotifier<int> _indicatorIndexNotifier = ValueNotifier<int>(0);
  final HallServicesAvailabilityCubit _hallServicesAvailabilityCubit =
      getIt<HallServicesAvailabilityCubit>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        _fabVisible) {
      setState(() => _fabVisible = false);
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        !_fabVisible) {
      setState(() => _fabVisible = true);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  CarouselSliderController carouselSliderController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _fabVisible
              ? FloatingActionButton.extended(
                onPressed: () {
                  _hallServicesAvailabilityCubit.emitHallServicesaAvailability(
                    widget.hall,
                  );
                },
                label: Container(
                  padding: EdgeInsets.all(8.h),
                  child: Text(
                    S.of(context).orderNow,
                    style: CustomTextStyle.font14BlackRegular,
                  ),
                ),
              )
              : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocListener<HallServicesAvailabilityCubit, BaseState>(
                bloc: _hallServicesAvailabilityCubit,
                listener: (context, state) {
                  if (state is LoadingState) {
                    loadingDialog(context);
                  }
                  if (state is ErrorState) {
                    context.pop();
                    errorDialog(
                      context,
                      message: state.apiErrorModel.error ?? "",
                    );
                  }
                  if (state is SuccessState<HallServicesAvailability>) {
                    context.pop();
                    context.pushNamed(
                      RoutesPath.resertvationLayout,
                      arguments: state.data,
                    );
                  }
                },
                child: SizedBox.shrink(),
              ),
              Gap(context.getStatusBarHeight()),

              SizedBox(
                height: context.getBodyHeight() / 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ConditionalBuilder(
                      condition: widget.hall.photos.isNotEmpty,
                      builder: (context) {
                        return Stack(
                          children: [
                            CarouselSlider(
                              carouselController: carouselSliderController,
                              options: CarouselOptions(
                                height: context.getBodyHeight() / 2,
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
                                  widget.hall.photos.map((photoModel) {
                                    String url =
                                        ApiConstants.baseUrl + photoModel.url;
                                    print(url);
                                    return CachedNetworkImage(
                                      imageUrl: url,
                                      placeholder:
                                          (context, url) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
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
                                              SvgPicture.asset(
                                                "assets/svg/logo.svg",
                                              ),
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                            ),
                            SizedBox(
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
                                          count: widget.hall.photos.length,
                                          effect: ExpandingDotsEffect(
                                            activeDotColor:
                                                AppColors().primaryColor,
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
                          (context) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: Text("Oops")),
                              const Gap(16.0),
                              Text(
                                "There is no images for this hall",
                                style: CustomTextStyle.font16BlackRegular,
                              ),
                            ],
                          ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: BackButton(
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.hall.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp, // responsive with ScreenUtil
                            fontWeight: FontWeight.w600, // semi‑bold
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: .1),
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ], // soft text shadow :contentReference[oaicite:3]{index=3}
                            color: Colors.grey[900], // deep, readable color
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey.withValues(alpha: .7),
                      ),
                      Text(
                        widget.hall.location,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.font12BlackRegular.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Gap(8.h),
                  ReadMoreText(
                    widget.hall.description,
                    trimMode: TrimMode.Line,
                    trimLines: 2,
                    colorClickableText: AppColors().secondColor,
                    trimCollapsedText: S.of(context).seeMore,
                    trimExpandedText: " ${S.of(context).seeLess}",
                  ),
                ],
              ),
              Gap(16.0.h),
            ],
          ),
        ),
      ),
    );
  }
}

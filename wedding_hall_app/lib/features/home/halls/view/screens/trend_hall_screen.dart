import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';
import 'package:wedding_hall_app/features/home/halls/view/cubit/trend_hall_cubit.dart';
import '../../../../../config/di/di.dart';
import '../../../../../config/routes/routes_path.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/custom_text_style.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core/domain/base_classes/base_state.dart';
import '../../../../core/view/screens/halls_resuable_screen.dart';
import '../../../home_screen/view/widgets/shimmers/hot_gifts_shimmer.dart';
import '../../data/models/hall.dart';
import '../cubit/halls_cubit.dart';

class TrendHallDetailsScreen extends StatefulWidget {
  final Hall hall;
  const TrendHallDetailsScreen({super.key, required this.hall});

  @override
  State<TrendHallDetailsScreen> createState() => _ProductOfferScreenState();
}

class _ProductOfferScreenState extends State<TrendHallDetailsScreen> {
  final TrendHallCubit _trendHallCubit = getIt<TrendHallCubit>();
  final ScrollController _scrollController = ScrollController();
  bool _fabVisible = true;

  @override
  void initState() {
    super.initState();
    _trendHallCubit.emitTrendHall();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          _fabVisible
              ? FloatingActionButton.extended(
                onPressed: () {
                  context.pushNamed(RoutesPath.resertvationLayout);
                },
                label: Container(
                  padding: EdgeInsets.all(8.h),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).orderNow,
                        style: CustomTextStyle.font14BlackRegular,
                      ),
                    ],
                  ),
                ),
              )
              : null,
      body: Container(),
    );
  }
}

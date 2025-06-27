import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/networking/api_error_model.dart';
import '../../domain/base_classes/base_state.dart';

class ReusableBlocBuilder<B extends BlocBase<BaseState>>
    extends StatelessWidget {
  final B Function() createCubit;
  final Widget Function(BuildContext context, BaseState state) builder;
  final Widget Function(ApiErrorModel error)? errorBuilder;
  final Widget Function()? shimmerBuilder;
  final void Function(B cubit)? onBuild;

  const ReusableBlocBuilder({
    super.key,
    required this.createCubit,
    required this.builder,
    this.errorBuilder,
    this.shimmerBuilder,
    this.onBuild,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (context) => createCubit(),
      child: _ReusableBlocBuilderContent<B>(
        builder: builder,
        errorBuilder: errorBuilder,
        shimmerBuilder: shimmerBuilder,
        onBuild: onBuild,
      ),
    );
  }
}

class _ReusableBlocBuilderContent<B extends BlocBase<BaseState>>
    extends StatelessWidget {
  final Widget Function(BuildContext context, BaseState state) builder;
  final Widget Function(ApiErrorModel error)? errorBuilder;
  final Widget Function()? shimmerBuilder;
  final void Function(B cubit)? onBuild;

  const _ReusableBlocBuilderContent({
    required this.builder,
    this.errorBuilder,
    this.shimmerBuilder,
    this.onBuild,
  });

  @override
  Widget build(BuildContext context) {
    if (onBuild != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cubit = context.read<B>();
        onBuild!(cubit);
      });
    }

    return BlocBuilder<B, BaseState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return shimmerBuilder != null ? shimmerBuilder!() : _defaultShimmer();
        } else if (state is ErrorState) {
          return errorBuilder != null
              ? errorBuilder!(state.apiErrorModel)
              : Center(
                  child: Text(
                    state.apiErrorModel.error ?? "",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
        } else {
          return builder(context, state);
        }
      },
    );
  }

  Widget _defaultShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                const Gap(16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Gap(8.0),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

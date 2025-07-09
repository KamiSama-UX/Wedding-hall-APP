import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';

import '../../domain/base_classes/base_state.dart';
import 'error_dialog.dart';
import 'loading_dialog.dart';
import 'success_dialog.dart';

class ReusableBlocListener<B extends BlocBase<BaseState>>
    extends StatelessWidget {
  final bool? showSuccessDialog;
  final String? successDialogMessage;
  final VoidCallback? onDialogOk;
  final B cubit;
  final Function(BuildContext context, BaseState currentState)? onStateChange;

  const ReusableBlocListener({
    super.key,
    this.onStateChange,
    this.showSuccessDialog,
    this.successDialogMessage,
    this.onDialogOk, required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, BaseState>(
      bloc: cubit,
      listener: (context, state) {
        if (onStateChange != null) {
          onStateChange!(context, state);
        }

        if (state is LoadingState) {
          loadingDialog(context);
        } else if (state is SuccessState) {
          if (showSuccessDialog != null && showSuccessDialog!) {
            successDialog(
              context: context,
              successDialogMessage: successDialogMessage!,
              onDialogOk: onDialogOk,
            );
          }
        } else if (state is ErrorState) {
          context.pop();
          errorDialog(
            context,
            message: state.apiErrorModel.error ?? "",
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

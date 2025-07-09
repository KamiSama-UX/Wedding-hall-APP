import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:pinput/pinput.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';

import '../../../../config/routes/routes_path.dart';
import '../../../../config/theme/custom_text_style.dart';
import '../../../../config/validation/text_form_validation.dart';
import '../../../../generated/l10n.dart';
import '../../../core/domain/base_classes/base_state.dart';
import '../../../core/view/widgets/reusable_bloc_listner.dart';
import '../../../core/view/widgets/scrollable_column_expanded.dart';
import '../cubit/enter_verification_code_cubit.dart';

class EnterVerificationCode extends StatefulWidget {
  final (String email, bool isRegister) record;
  const EnterVerificationCode({super.key, required this.record});

  @override
  State<EnterVerificationCode> createState() => _EnterVerificationCodeState();
}

class _EnterVerificationCodeState extends State<EnterVerificationCode> {
  int verificationCodeLength = 6;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  late String emailValue;
  @override
  void initState() {
    emailValue = widget.record.$1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Form(
        key: formKey,
        child: ScrollColumnExpandable(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          children: [
            ReusableBlocListener<EnterVerificationCodeCubit>(
              cubit: context.read<EnterVerificationCodeCubit>(),
              showSuccessDialog: widget.record.$2,
              successDialogMessage: widget.record.$2 ? S.of(context).yourAccountReadyToUse : null,
              onStateChange: (context, currentState) {
                if (currentState is SuccessState) {
                  if (widget.record.$2) {
                    context.pushNamedAndRemoveUntil(
                      RoutesPath.login,
                      predicate: (route) => false,
                    );
                  } else {
                    context.pushNamedAndRemoveUntil(
                      RoutesPath.resetPassword,
                      predicate: (route) => false,
                    );
                  }
                }
              },
            ),
            SvgPicture.asset("assets/svg/logo.svg"),
            Text(
              S.of(context).verifyYourEmail,
              style: CustomTextStyle.font20BlackSemiBold,
            ),
            Gap(32.0.h),
            Text(
              S.of(context).EnterTheDigitsVerificationCode,
              textAlign: TextAlign.center,
              style: CustomTextStyle.font14BlackRegular,
            ),
            Gap(32.0.h),
            KeyboardVisibility(
              onChanged: (isShown) {
                if (!isShown) FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Pinput(
                controller: codeController,
                length: verificationCodeLength,
                validator: (value) {
                  return TextFormValidation.verifyCodeValidator(
                    context,
                    value: value,
                    maxLength: verificationCodeLength,
                  );
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onCompleted: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },

                defaultPinTheme: PinTheme(
                  width: 40.w,
                  height: 48.h,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(width: 0.5),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // if (formKey.currentState!.validate()) {
                  //   context.read<EnterVerificationCodeCubit>().emitVerify(
                  //     VerifyEmailRequestBody(
                  //       email: emailValue,
                  //       code: codeController.text,
                  //     ),
                  //   );
                  // }
                  context.pushNamedAndRemoveUntil(
                      RoutesPath.resetPassword,
                      predicate: (route) => false,
                      arguments: emailValue,
                    );
                },
                child: Text(S.of(context).verifyEmail),
              ),
            ),
            Gap(10.0.h),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';

import '../../../../config/routes/routes_path.dart';
import '../../../../config/theme/custom_text_style.dart';
import '../../../../config/validation/text_form_validation.dart';
import '../../../../generated/l10n.dart';
import '../../../core/domain/base_classes/base_state.dart';
import '../../../core/view/widgets/custom_text_field.dart';
import '../../../core/view/widgets/reusable_bloc_listner.dart';
import '../../../core/view/widgets/scrollable_column_expanded.dart';
import '../../data/models/reset_password_request_body.dart';
import '../cubit/reset_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController codeController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email;
  int verificationCodeLength = 6;
  @override
  void initState() {
    email = widget.email;
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    codeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
          child: ScrollColumnExpandable(
            children: [
              ReusableBlocListener<ResetPasswordCubit>(
                cubit: context.read<ResetPasswordCubit>(),
                showSuccessDialog: true,
                successDialogMessage: S.of(context).passwordChangedSuccessfly,
                onStateChange: (context, currentState) {
                  if (currentState is SuccessState) {
                    context.pushNamedAndRemoveUntil(
                      RoutesPath.login,
                      predicate: (route) => false,
                    );
                  }
                },
              ),
              SvgPicture.asset("assets/svg/logo.svg"),
              Text(
                S.of(context).changeYourPassword,
                style: CustomTextStyle.font20BlackSemiBold,
              ),
              Gap(32.0.h),
              Text(
                S.of(context).pleaseEnterYourNewPasswordAndConfirmIt,
                style: CustomTextStyle.font14BlackRegular,
              ),              
              Gap(16.h),
              KTextForm(
                controller: passwordController,
                hintText: S.of(context).password,
                validator: (value) {
                  return TextFormValidation.passwordValidate(
                    context,
                    value: value,
                  );
                },
              ),
              Gap(8.0.h),
              KTextForm(
                controller: confirmPasswordController,
                hintText: S.of(context).confirmPassword,
                validator: (value) {
                  return TextFormValidation.confirmPasswordValidation(
                    context,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );
                },
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<ResetPasswordCubit>().emitResetPassword(
                          ResetPasswordRequestBody(
                            newPassword: passwordController.text,
                            email: email,
                          ),
                        );
                      }
                    },
                    child: Text(S.of(context).changeYourPassword),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
import '../../../core/data/models/success_response.dart';
import '../../../core/domain/base_classes/base_state.dart';
import '../../../core/view/widgets/custom_text_field.dart';
import '../../../core/view/widgets/reusable_bloc_listner.dart';
import '../cubit/sign_up_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController confirmPasswordController;

  @override
  initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
        emailController.text = "beviyo9281@amgens.com";
    passwordController.text = "@Tt123456";
    confirmPasswordController.text = "@Tt123456";
    nameController.text = "Waseem Alqahwaji";
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ReusableBlocListener<SignUpCubit>(
                    cubit: context.read<SignUpCubit>(),
                    onStateChange: (context, currentState) {
                      if (currentState is SuccessState) {
                        final SuccessResponse successResponse =
                            currentState.data;
                        if (successResponse.statusCode == 1000) {
                          context.pushNamed(
                            RoutesPath.enterVerificationCode,
                            arguments: emailController.text,
                          );
                          return;
                        }
                        context.pushNamed(
                          RoutesPath.enterVerificationCode,
                          arguments: emailController.text,
                        );
                      }
                    },
                  ),
                  Gap(48.h),
                  SvgPicture.asset("assets/svg/logo.svg"),
                  Text(
                    S.of(context).letsGetStarted,
                    style: CustomTextStyle.font20BlackSemiBold,
                  ),
                  Text(
                    "Enter The Golden Cage",
                    style: CustomTextStyle.font13BlackRegular,
                  ),
                  Gap(16.0.h),
                  KTextForm(
                    controller: nameController,
                    hintText: S.of(context).name,
                    validator: (value) {
                      return TextFormValidation.isNullOrEmptyValidator(
                        context,
                        value: value,
                      );
                    },
                  ),
                  Gap(12.0.h),
                  KTextForm(
                    controller: emailController,
                    hintText: S.of(context).email,
                    validator: (value) {
                      return TextFormValidation.emailValidator(
                        context,
                        value: value,
                      );
                    },
                  ),

                  Gap(12.0.h),
                  KTextForm(
                    controller: passwordController,
                    hintText: S.of(context).password,
                    type: TextInputType.visiblePassword,
                    validator: (value) {
                      return TextFormValidation.passwordValidate(
                        context,
                        value: value,
                      );
                    },
                  ),
                  Gap(12.0.h),
                  KTextForm(
                    controller: confirmPasswordController,
                    hintText: S.of(context).confirmPassword,
                    type: TextInputType.visiblePassword,
                    validator: (value) {
                      return TextFormValidation.confirmPasswordValidation(
                        context,
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                      );
                    },
                  ),
                  Gap(16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // context.read<SignUpCubit>().emitSignup(
                          //   SignUpRequestBody(
                          //     email: emailController.text.trim(),
                          //     password: passwordController.text,
                          //     name: nameController.text.trim(),
                          //   ),
                          // );
                          context.pushNamed(
                            RoutesPath.enterVerificationCode,
                            arguments: (emailController.text, true),
                          );
                        }
                      },
                      child: Text(S.of(context).letsGo),
                    ),
                  ),
                  Gap(16.h),
                  InkWell(
                    onTap: () {
                      context.pushNamed(RoutesPath.login);
                    },
                    child: Text(
                      "Already have an account ?",
                      style: CustomTextStyle.font12PrimaryColorBoldUnderline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

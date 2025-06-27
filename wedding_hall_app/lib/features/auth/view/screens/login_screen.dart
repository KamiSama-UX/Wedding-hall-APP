import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';

import '../../../../config/di/di.dart';
import '../../../../config/routes/routes_path.dart';
import '../../../../config/theme/custom_text_style.dart';
import '../../../../config/validation/text_form_validation.dart';
import '../../../../generated/l10n.dart';
import '../../../core/domain/base_classes/base_state.dart';
import '../../../core/view/widgets/custom_text_field.dart';
import '../../../core/view/widgets/reusable_bloc_listner.dart';
import '../../data/models/login_request_body.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool remamberMe = true;

  @override
  Widget build(BuildContext context) {
    emailController.text = "waseemalqahwaji123@gmail.com";
    passwordController.text = "examplePassword";
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
        child: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableBlocListener<LoginCubit>(
                    cubit: getIt<LoginCubit>(),
                    onStateChange: (context, currentState) {
                      if (currentState is SuccessState) {
                        context.pushNamedAndRemoveUntil(
                          RoutesPath.homeLayout,
                          predicate: (route) => false,
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

                    // validator: (value) {
                    //   return TextFormValidation.passwordValidate(
                    //     context,
                    //     value: value,
                    //   );
                    // },
                  ),
                  Gap(8.h),
                  Row(
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: remamberMe,
                        onChanged: (value) {
                          remamberMe = !remamberMe;
                          setState(() {});
                        },
                      ),
                      Text("Remember Me"),
                    ],
                  ),
                  Gap(16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account ? ",
                        style: CustomTextStyle.font12BlackRegular,
                      ),
                      InkWell(
                        onTap: () => context.pushNamed(RoutesPath.signUp),
                        child: Text(
                          "Create Account",
                          style:
                              CustomTextStyle.font12PrimaryColorBoldUnderline,
                        ),
                      ),
                    ],
                  ),
                  Gap(16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<LoginCubit>().emitLogin(
                            LoginRequestBody(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        }
                      },
                      child: Text(S.of(context).letsGo),
                    ),
                  ),
                  Gap(16.h),
                  InkWell(
                    onTap: () {
                      context.pushNamed(RoutesPath.enterEmail);
                    },
                    child: Text(
                      "Forget Password ?",
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
